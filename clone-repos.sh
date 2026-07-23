#!/usr/bin/env bash
# Clone the PostHog repo landscape (from the /phs posthog-repos skill) flat into ~,
# matching the template-provisioned ~/posthog. Shallow for speed — deepen later with
# `git fetch --unshallow` if full history is needed. Idempotent: skips existing dirs;
# failures (e.g. Coder external auth not ready yet) retry on the next workspace start.
set -uo pipefail

REPOS=(
  posthog.com code
  charts posthog-cloud-infra runbooks
  posthog-js posthog-python posthog-go
  ai-plugin signals-chaos
  twig.com llm-analytics-apps skills posthog-demo-3000
  requests-for-comments-internal
)

for repo in "${REPOS[@]}"; do
  dir="$HOME/${repo}"
  [ -d "$dir" ] && continue
  echo "coder-dotfiles: cloning ${repo}..."
  git clone --depth 1 "https://github.com/PostHog/${repo}.git" "$dir" \
    || echo "coder-dotfiles: clone FAILED for ${repo} (will retry next start)"
done
echo "coder-dotfiles: repo clones done"
