# codebase-memory reference

Details for the tools, data model, and Cypher subset. Read this when you need an
argument shape or a query pattern that is not in `SKILL.md`.

All examples assume the helper:

```powershell
$cbm = "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1"
```

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

Node labels observed in C#/TypeScript repositories, in rough frequency order:
`Field`, `Method`, `Variable`, `Class`, `File`, `Module`, `Folder`, `Interface`,
`Enum`, `Decorator`, `Function`, `Section`, `Route`. `Function` is rare in C#
because members are `Method`.

Edge types: `DEFINES`, `DEFINES_METHOD`, `WRITES`, `CALLS`, `IMPORTS`, `USAGE`,
`INHERITS`, `DECORATES`, `THROWS`, `RAISES`, `TESTS`, `CONTAINS_FILE`,
`CONTAINS_FOLDER`, `SIMILAR_TO`, `SEMANTICALLY_RELATED`, `FILE_CHANGES_WITH`,
`HTTP_CALLS`, `GRPC_CALLS`.

`CALLS` carries `confidence`, `strategy`, and `candidates`, so a low-confidence
edge is a guess rather than a resolved call. `FILE_CHANGES_WITH` comes from git
history with `co_changes` and `coupling_score` — useful for "what else usually
changes with this file".

Qualified names are `<project>.<path parts>.<name>`, and for a method the class
segment repeats: `...Business.CardValidator.CardValidator.AddressVerification`.
Never construct one by hand; get it from `search_graph` or `search_code` and pass
it verbatim to `get_code_snippet`.

Run `get_graph_schema` on an unfamiliar project first — it returns exact label
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
& $cbm query_graph '{"project":"P","query":"MATCH (m:Method) WHERE m.is_exported = true AND m.is_test = false AND NOT EXISTS { (m)<-[:CALLS]-() } RETURN m.qualified_name, m.file_path LIMIT 25"}'
```

Implementations of an interface:

```powershell
& $cbm query_graph '{"project":"P","query":"MATCH (c:Class)-[:INHERITS]->(i:Interface) WHERE i.name = ''IPaymentMethodDAO'' RETURN c.name, c.file_path"}'
```

Most complex methods in one area:

```powershell
& $cbm query_graph '{"project":"P","query":"MATCH (m:Method) WHERE m.file_path STARTS WITH ''Services/PaymentMethod/'' RETURN m.qualified_name, m.complexity ORDER BY m.complexity DESC LIMIT 15"}'
```

Files that historically change together:

```powershell
& $cbm query_graph '{"project":"P","query":"MATCH (a:File)-[r:FILE_CHANGES_WITH]->(b:File) RETURN a.name, b.name, r.co_changes ORDER BY r.co_changes DESC LIMIT 20"}'
```

Cross-repo: index several repositories into the same store and run the same query
against each `project` in turn; `CROSS_*` edges link nodes that the indexer
matched across repositories.

## Impact analysis

`detect_changes` maps the git diff onto affected symbols and their blast radius.
It reads the diff, so **untracked files produce no results** — stage them or
compare against the graph with `search_graph` instead.

```powershell
& $cbm detect_changes '{"project":"P","depth":2}'
```

Returns `changed_files`, `impacted_symbols`, and `depth`. Follow up with
`trace_path` inbound on each impacted symbol to see who would be affected.

## Troubleshooting

| Symptom | Cause and fix |
|---|---|
| `<field> is required` despite passing it | JSON argument was split on spaces by PowerShell. Use `scripts/cbm.ps1`, never the raw binary. |
| `--repo-path` and `--help` rejected | v0.8.1 has no flag parsing. Usage is `cli [--progress] [--json] <tool> [json_args]`; JSON is the only way to pass arguments. Piping JSON on stdin does not work either. |
| `trace_path` returns empty `callers` | The name matched a constructor or an unresolved call. Confirm the exact name with `search_graph` first, and remember unresolved calls emit no edge. |
| Results look outdated | `auto_index` is `false`, so nothing re-indexes automatically. Re-run `index_repository`. |
| `search_code` warns it took over 5s | Narrow with `file_pattern` or `path_filter`, or use `search_graph` on names instead. |
| `index_repository` returns `status: degraded` | Persisted node count fell below the in-memory count. Re-index; if it repeats, delete the project and index fresh. |
| Wrong project's results | `project` was omitted or misspelled. Get exact names from `list_projects`. |

## Installation facts

- Binary: `%LOCALAPPDATA%/Programs/codebase-memory-mcp/codebase-memory-mcp.exe`,
  version 0.8.1, 14 tools. Override the location with `$env:CBM_EXE`.
- Registered as an MCP server in `~/.cursor/mcp.json`, but its tools are not
  always exposed to the agent session — the CLI path always works.
- Graph databases live in `~/.cache/codebase-memory-mcp/`. Config: `auto_index`
  (`false`) and `auto_index_limit` (`50000`), managed with
  `codebase-memory-mcp config set <key> <value>`.
- Ignore layers, in order: built-in patterns (`.git`, `node_modules`, `bin`,
  `obj`), the `.gitignore` hierarchy, then `.cbmignore` in the repo root.
- Optional `.codebase-memory.json` in a repo root maps extra file extensions to
  languages, e.g. `{"extra_extensions": {".cshtml": "html"}}`.
