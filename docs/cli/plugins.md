---
summary: "CLI reference for `Xcriminal plugins` (list, install, enable/disable, doctor)"
read_when:
  - You want to install or manage in-process Gateway plugins
  - You want to debug plugin load failures
---

# `Xcriminal plugins`

Manage Gateway plugins/extensions (loaded in-process).

Related:
- Plugin system: [Plugins](/plugin)
- Plugin manifest + schema: [Plugin manifest](/plugins/manifest)
- Security hardening: [Security](/gateway/security)

## Commands

```bash
Xcriminal plugins list
Xcriminal plugins info <id>
Xcriminal plugins enable <id>
Xcriminal plugins disable <id>
Xcriminal plugins doctor
Xcriminal plugins update <id>
Xcriminal plugins update --all
```

Bundled plugins ship with Xcriminal but start disabled. Use `plugins enable` to
activate them.

All plugins must ship a `Xcriminal.plugin.json` file with an inline JSON Schema
(`configSchema`, even if empty). Missing/invalid manifests or schemas prevent
the plugin from loading and fail config validation.

### Install

```bash
Xcriminal plugins install <path-or-spec>
```

Security note: treat plugin installs like running code. Prefer pinned versions.

Supported archives: `.zip`, `.tgz`, `.tar.gz`, `.tar`.

Use `--link` to avoid copying a local directory (adds to `plugins.load.paths`):

```bash
Xcriminal plugins install -l ./my-plugin
```

### Update

```bash
Xcriminal plugins update <id>
Xcriminal plugins update --all
Xcriminal plugins update <id> --dry-run
```

Updates only apply to plugins installed from npm (tracked in `plugins.installs`).
