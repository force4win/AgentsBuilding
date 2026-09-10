# codebase-memory reference

Details for the tools, data model, and Cypher subset. Read this when you need an
argument shape or a query pattern that is not in `SKILL.md`.

All examples assume the helper and a project name from `list_projects`:

```powershell
$cbm = "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1"
$p = "D-LeapFactor-HWAY-codigo-NMC-numiv2"
```

## Installation

The skill is IDE-level, so it applies to every project, but the engine is a local
binary installed once per machine.

1. Install `codebase-memory-mcp` from <https://github.com/DeusData/codebase-memory-mcp>.
   On Windows the installer lands at
   `%LOCALAPPDATA%/Programs/codebase-memory-mcp/codebase-memory-mcp.exe`, which the
   helper finds automatically. Set `$env:CBM_EXE` to override the location.
2. Graph databases live under `~/.cache/codebase-memory-mcp/` and persist across
   restarts. Each indexed repository is a separate project in one shared store.
3. Optional: `codebase-memory-mcp config set auto_index true` makes new projects
   index on session start, which removes most of the staleness problem.

The binary is also registered as an MCP server in `~/.cursor/mcp.json`, but its
tools are not always exposed to the agent session — the CLI path always works.

On macOS and Linux the PowerShell quoting problem does not exist; call the binary
directly with `codebase-memory-mcp cli <tool> '<json>'`.

## Tool arguments

Every tool except `list_projects` and `index_repository` requires `project`.

| Tool | Arguments |
|---|---|
| `index_repository` | `repo_path` (absolute, forward slashes) |
| `index_status` | `project` |
| `list_projects` | none |
| `delete_project` | `project` |
| `search_graph` | `project`, `name_pattern` (regex), `label`, `file_pattern` (SQL `LIKE`, `%` wildcard), `min_degree`, `max_degree`, `limit`, `offset` |
| `query_graph` | `project`, `query` (Cypher) |
| `trace_path` | `project`, `function_name`, `direction` (`inbound` / `outbound` / `both`), `max_depth` (1-5) |
| `get_code_snippet` | `project`, `qualified_name` |
| `get_graph_schema` | `project` |
| `get_architecture` | `project`, `aspects` (array) |
| `search_code` | `project`, `pattern`, `file_pattern`, `path_filter`, `limit` |
| `detect_changes` | `project`, `depth` |
| `manage_adr` | `project`, `mode` (`store` / `update` / read) |
| `ingest_traces` | `project`, trace payload |

`get_architecture` aspects include `languages`, `packages`, `entry_points`,
`routes`, `hotspots`, `boundaries`, `layers`, `clusters`, and `all`. Request only
what you need; `all` returns a very large document.

## Data model

Node labels, in the frequency order typical of a C#/TypeScript solution: `Field`,
`Method`, `Variable`, `Class`, `File`, `Module`, `Folder`, `Interface`, `Enum`,
`Decorator`, `Function`, `Section`, `Route`. `Function` is rare in C# because
members are `Method`.

Edge types: `DEFINES`, `DEFINES_METHOD`, `WRITES`, `CALLS`, `IMPORTS`, `USAGE`,
`INHERITS`, `DECORATES`, `THROWS`, `RAISES`, `TESTS`, `CONTAINS_FILE`,
`CONTAINS_FOLDER`, `SIMILAR_TO`, `SEMANTICALLY_RELATED`, `FILE_CHANGES_WITH`,
`HTTP_CALLS`, `GRPC_CALLS`.

`CALLS` carries `confidence`, `strategy`, and `candidates`, so a low-confidence
edge is a guess rather than a resolved call. `FILE_CHANGES_WITH` comes from git
history with `co_changes` and `coupling_score` — useful for "what else usually
changes with this file". C# classes implementing an interface are linked with
`INHERITS`, not `IMPLEMENTS`.

Qualified names are `<project>.<path parts>.<name>`, and for a method the class
segment repeats:
`<project>.Services.PaymentMethod.PaymentMethodAPI.Business.CardValidator.CardValidator.AddressVerificationDeprecated`.
Never construct one by hand; get it from `search_graph` or `search_code` and pass
it verbatim to `get_code_snippet`.

Run `get_graph_schema` first on an unfamiliar project — it returns exact label
counts, edge counts, and the property list per label, which tells you what is
worth querying.

## Cypher subset

`query_graph` accepts a read-only openCypher subset: `MATCH`, `OPTIONAL MATCH`,
`WHERE`, `WITH`, `RETURN`, `ORDER BY`, `SKIP`, `LIMIT`, `DISTINCT`, `UNWIND`,
`UNION`, `CASE`, variable-length paths `[*1..3]`, label alternation `(n:A|B)`,
and `EXISTS { (n)-[:TYPE]->() }`. Aggregates: `count`, `sum`, `avg`, `min`,
`max`, `collect`. Writes, `MERGE`, `CALL`, list/map literals, comprehensions, and
query parameters are rejected with an explicit `unsupported ...` error rather
than returning empty results.

### Query recipes

Dead code — exported methods nobody calls:

```powershell
& $cbm query_graph "{`"project`":`"$p`",`"query`":`"MATCH (m:Method) WHERE m.is_exported = true AND m.is_test = false AND NOT EXISTS { (m)<-[:CALLS]-() } RETURN m.qualified_name, m.file_path LIMIT 25`"}"
```

Implementations of an interface:

```powershell
& $cbm query_graph "{`"project`":`"$p`",`"query`":`"MATCH (c:Class)-[:INHERITS]->(i:Interface) WHERE i.name = ''IPaymentMethodDAO'' RETURN c.name, c.file_path`"}"
```

Most complex methods in one area:

```powershell
& $cbm query_graph "{`"project`":`"$p`",`"query`":`"MATCH (m:Method) WHERE m.file_path STARTS WITH ''Services/PaymentMethod/'' RETURN m.qualified_name, m.complexity ORDER BY m.complexity DESC LIMIT 15`"}"
```

Files that historically change together:

```powershell
& $cbm query_graph "{`"project`":`"$p`",`"query`":`"MATCH (a:File)-[r:FILE_CHANGES_WITH]->(b:File) RETURN a.name, b.name, r.co_changes ORDER BY r.co_changes DESC LIMIT 20`"}"
```

Cross-repo: index sibling repositories into the same store and run the same query
against each `project` in turn; `CROSS_*` edges link nodes the indexer matched
across repositories.

## Impact analysis

`detect_changes` maps the git diff onto affected symbols and their blast radius.
It reads the diff, so **untracked files produce no results** — stage them or
locate them with `search_graph` instead.

```powershell
& $cbm detect_changes "{`"project`":`"$p`",`"depth`":2}"
```

Returns `changed_files`, `impacted_symbols`, and `depth`. Follow up with
`trace_path` inbound on each impacted symbol to see who would be affected.

## Noise control

Generated and vendored code dominates node counts and swamps dead-code results:
WCF/SOAP service references, `*.designer.cs`, protobuf stubs, and SDK clients
checked into the tree. Filter them out with `file_pattern`, or with a clause like
`WHERE NOT m.file_path CONTAINS 'Service References'`.

Ignore layers apply in order: built-in patterns (`.git`, `.vs`, `node_modules`,
`bin`, `obj`), the `.gitignore` hierarchy, then `.cbmignore` in the repo root.
Add a `.cbmignore` when a repo has large indexed directories that are never worth
querying.

Framework-specific extensions such as `.cshtml` are not indexed by default. Map
them per repository with a `.codebase-memory.json` in the root, e.g.
`{"extra_extensions": {".cshtml": "html"}}`.

## Troubleshooting

| Symptom | Cause and fix |
|---|---|
| `<field> is required` despite passing it | JSON argument was split on spaces by PowerShell. Use `scripts/cbm.ps1`, never the raw binary. |
| `--repo-path` and `--help` rejected | v0.8.1 has no flag parsing. Usage is `cli [--progress] [--json] <tool> [json_args]`; JSON is the only way to pass arguments. Piping JSON on stdin does not work either. |
| `codebase-memory-mcp binary not found` | Not installed, or installed elsewhere. See "Installation" and set `$env:CBM_EXE`. |
| `project not found or not indexed` | Expected for a new repo. Offer to index it, per Step 0 in `SKILL.md`. The error lists `available_projects`. |
| `trace_path` returns empty `callers` | The name matched a constructor or an unresolved call. Confirm the exact name with `search_graph` first, and remember unresolved calls emit no edge. |
| Results look outdated | `auto_index` defaults to `false`, so nothing re-indexes automatically. Re-run `index_repository`. |
| `search_code` warns it took over 5s | Narrow with `file_pattern` or `path_filter`, or use `search_graph` on names instead. |
| `index_repository` returns `status: degraded` | Persisted node count fell below the in-memory count. Re-index; if it repeats, delete the project and index fresh. |
| Wrong project's results | `project` was omitted or misspelled. Get exact names from `list_projects`. |
