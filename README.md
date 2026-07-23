# coder-dotfiles

Personal customizations for PostHog Coder devboxes. Coder clones this repo and runs `install.sh` on every workspace start.

Wired up once via:

```bash
hogli devbox:setup --configure-dotfiles
```

## What it does

- Adds shell aliases (`gcm`, `gcmm`, `gpp`) via a managed block in `~/.bash_aliases`
- Reapplies git commit-signing config from the `POSTHOG_GIT_SIGNING_KEY` secret if the template's boot-time bootstrap raced and left the box unconfigured

## Rules

- Keep `install.sh` idempotent — it runs on every start
- No secrets in this repo (it may be public); secrets go in `hogli devbox:secret:set`
- Don't duplicate what the platform already handles: git identity, Claude token, gh auth
