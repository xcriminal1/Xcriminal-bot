---
summary: "CLI reference for `Xcriminal voicecall` (voice-call plugin command surface)"
read_when:
  - You use the voice-call plugin and want the CLI entry points
  - You want quick examples for `voicecall call|continue|status|tail|expose`
---

# `Xcriminal voicecall`

`voicecall` is a plugin-provided command. It only appears if the voice-call plugin is installed and enabled.

Primary doc:
- Voice-call plugin: [Voice Call](/plugins/voice-call)

## Common commands

```bash
Xcriminal voicecall status --call-id <id>
Xcriminal voicecall call --to "+15555550123" --message "Hello" --mode notify
Xcriminal voicecall continue --call-id <id> --message "Any questions?"
Xcriminal voicecall end --call-id <id>
```

## Exposing webhooks (Tailscale)

```bash
Xcriminal voicecall expose --mode serve
Xcriminal voicecall expose --mode funnel
Xcriminal voicecall unexpose
```

Security note: only expose the webhook endpoint to networks you trust. Prefer Tailscale Serve over Funnel when possible.

