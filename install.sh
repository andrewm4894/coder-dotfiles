#!/usr/bin/env bash
# Applied automatically by Coder on devbox creation/restart (via hogli devbox:setup --configure-dotfiles).
# Must stay idempotent: runs on every workspace start.
set -euo pipefail

# --- Shell aliases (managed block, won't clobber manual additions) ---
if ! grep -q '# >>> coder-dotfiles >>>' ~/.bash_aliases 2>/dev/null; then
  cat >> ~/.bash_aliases << 'EOF'
# >>> coder-dotfiles >>>
alias gcm='git checkout master'
alias gcmm='git checkout main'
alias gpp='git pull'
# <<< coder-dotfiles <<<
EOF
fi

# --- Commit signing safety net ---
# The posthog-linux template configures signing from the POSTHOG_GIT_SIGNING_KEY
# secret at boot, but its bootstrap can race ("Bootstrap did not complete before
# Git identity sync") and leave the box unsigned. Reapply if that happened.
if [ -n "${POSTHOG_GIT_SIGNING_KEY:-}" ] && [ "$(git config --global --get commit.gpgsign || true)" != "true" ]; then
  git config --global gpg.format ssh
  git config --global user.signingkey "key::${POSTHOG_GIT_SIGNING_KEY#key::}"
  git config --global commit.gpgsign true
  git config --global tag.gpgsign true
  echo "coder-dotfiles: reapplied git signing config (template bootstrap had not)"
fi

# --- Clone the PostHog repo landscape (see clone-repos.sh) ---
# Backgrounded so workspace start isn't blocked by ~15 clones.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nohup bash "$SCRIPT_DIR/clone-repos.sh" >> "$HOME/.coder-dotfiles-clone.log" 2>&1 &

echo "coder-dotfiles: install.sh done (repo clones continue in background, see ~/.coder-dotfiles-clone.log)"
