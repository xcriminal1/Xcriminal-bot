---
summary: "CLI reference for `Xcriminal config` (get/set/unset config values)"
read_when:
  - You want to read or edit config non-interactively
---

# `Xcriminal config`

Config helpers: get/set/unset values by path. Run without a subcommand to open
the configure wizard (same as `Xcriminal configure`).

## Examples

```bash
Xcriminal config get browser.executablePath
Xcriminal config set browser.executablePath "/usr/bin/google-chrome"
Xcriminal config set agents.defaults.heartbeat.every "2h"
Xcriminal config set agents.list[0].tools.exec.node "node-id-or-name"
Xcriminal config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
Xcriminal config get agents.defaults.workspace
Xcriminal config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
Xcriminal config get agents.list
Xcriminal config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--json` to require JSON5 parsing.

```bash
Xcriminal config set agents.defaults.heartbeat.every "0m"
Xcriminal config set gateway.port 19001 --json
Xcriminal config set channels.whatsapp.groups '["*"]' --json
```

Restart the gateway after edits.
