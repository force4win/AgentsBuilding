---
name: codebase-memory
description: >-
  Queries the local codebase-memory-mcp knowledge graph (a persistent structural
  index of the codebase) instead of grep/glob/file-by-file reading. Use it FIRST,
  before any other codebase exploration, for questions about where a symbol lives,
  who calls what, the blast radius of a change, architecture and entry points,
  hotspots, dead code, inheritance, or cross-service links. Also use when indexing
  or re-indexing a repository, checking index freshness, or when the user mentions
  codebase-memory, cbm, knowledge graph, grafo, indexar, or "indexa".
---

# codebase-memory

A local knowledge graph of the codebase (functions, classes, calls, imports,
routes, git co-change) that answers structural questions in milliseconds. It
replaces dozens of grep/read cycles with one query.

## Use the graph first

Before reaching for `Grep`, `Glob`, `codebase_search`, or reading files to orient
yourself, ask whether the question is **structural**. If it is, query the graph
first and use its answer to decide which few files to actually open.

| Question | Query first |
|---|---|
| Where is `X` defined? What is named like `X`? | `search_graph` with `name_pattern` |
| Who calls `X`? What does `X` call? | `trace_path` with `direction` |
| What breaks if I change `X`? | `detect_changes`, then `trace_path` inbound |
| How is this repo organized? Entry points? Hotspots? | `get_architecture` |
| Show me the body of `X` | `get_code_snippet` with `qualified_name` |
| Find text `T` across the code | `search_code` |
| Anything else structural (inheritance, dead code, fan-in) | `query_graph` with Cypher |

**Always follow up with a real file read before editing.** The graph reflects the
last index, not the working tree. Treat it as a map, not as the source of truth.

## Use normal tools instead when

- The file changed after the last index, or you need its exact current contents.
- The target is not indexed: build output, binaries, or anything in `.gitignore`.
- The question is about git history, runtime behavior, logs, or dependencies.
- `list_projects` does not contain the repository and indexing it is not wanted.
- A clean graph result means "no recorded relationship", never proof of absence.
  Before making a negative claim ("nothing calls this"), confirm with a grep.

## Running a tool

Use the bundled helper. It prints the tool's JSON on stdout and hides the
binary's info log unless something fails.

```powershell
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" <tool> '<json>'
```

```powershell
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" list_projects
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" search_graph '{"project":"my-project","name_pattern":".*Validator.*","label":"Class","limit":10}'
```

Do **not** invoke the binary directly with a JSON argument. Windows PowerShell
splits native-command arguments on spaces, so any JSON value containing a space
arrives truncated and the tool fails with `<field> is required`. The helper builds
the command line explicitly to avoid this. Inside a Cypher string, escape single
quotes by doubling them: `WHERE c.name CONTAINS ''Validator''`.

## Standard workflow

1. **Locate the project.** Run `list_projects` and match on `root_path`. Project
   names are derived from the absolute path, e.g. `D:/LeapFactor/HWAY/codigo/NMC/numiv2`
   becomes `D-LeapFactor-HWAY-codigo-NMC-numiv2`. Every other tool needs `project`.
2. **Check freshness.** `auto_index` is off on this machine, so nothing re-indexes
   on its own. Run `index_status`; if the repo has changed meaningfully since the
   last index, re-run `index_repository`. A full re-index of a 4k-file repo takes
   about 20 seconds, so prefer re-indexing over reasoning on a stale graph.
3. **Query broad, then narrow.** `get_graph_schema` or `get_architecture` for
   orientation, then `search_graph` to find exact qualified names, then
   `trace_path` / `query_graph` for relationships.
4. **Read the real files** for the handful of paths the graph pointed you to, and
   only then edit.

## Indexing

```powershell
& "$env:USERPROFILE/.cursor/skills/codebase-memory/scripts/cbm.ps1" index_repository '{"repo_path":"D:/path/to/repo"}'
```

Use forward slashes; backslashes would need JSON escaping. The path must be
absolute. Indexing is incremental after the first run and respects `.gitignore`
plus `.cbmignore`. The result reports `nodes`, `edges`, and excluded directories;
a `status` of `degraded` means persistence lost nodes and the index should be
rebuilt.

Several repositories can share the store, which is what enables cross-repo
queries. Index each one separately with its own `repo_path`.

## Tools

`index_repository`, `index_status`, `list_projects`, `delete_project`,
`search_graph`, `query_graph`, `trace_path`, `get_code_snippet`,
`get_graph_schema`, `get_architecture`, `search_code`, `detect_changes`,
`manage_adr`, `ingest_traces`.

For argument shapes, node labels, edge types, the supported Cypher subset, and
worked examples, see [reference.md](reference.md).

## Cost control

Graph results can be large. Keep responses small so the saved tokens are not
given back:

- Always pass `limit` to `search_graph` and `search_code`; start at 10.
- Narrow `search_graph` with `label` and `file_pattern` rather than filtering
  a large result set afterwards.
- Ask `get_architecture` for specific `aspects` instead of `["all"]`.
- Prefer `query_graph` returning named columns over `search_graph`, whose rows
  carry large fingerprint and signature fields.
