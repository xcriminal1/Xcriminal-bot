---
summary: "CLI reference for `Xcriminal logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
---

# `Xcriminal logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:
- Logging overview: [Logging](/logging)

## Examples

```bash
Xcriminal logs
Xcriminal logs --follow
Xcriminal logs --json
Xcriminal logs --limit 500
```

