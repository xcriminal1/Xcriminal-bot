---
summary: "CLI reference for `Xcriminal onboard` (interactive onboarding wizard)"
read_when:
  - You want guided setup for gateway, workspace, auth, channels, and skills
---

# `Xcriminal onboard`

Interactive onboarding wizard (local or remote Gateway setup).

Related:
- Wizard guide: [Onboarding](/start/onboarding)

## Examples

```bash
Xcriminal onboard
Xcriminal onboard --flow quickstart
Xcriminal onboard --flow manual
Xcriminal onboard --mode remote --remote-url ws://gateway-host:18789
```

Flow notes:
- `quickstart`: minimal prompts, auto-generates a gateway token.
- `manual`: full prompts for port/bind/auth (alias of `advanced`).
- Fastest first chat: `Xcriminal dashboard` (Control UI, no channel setup).
