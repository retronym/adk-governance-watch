#!/usr/bin/env bash
#
# clone.sh — clone (or update) all sub-repos listed in repos.txt.
#
# The sub-repo working copies are git-ignored; this script reconstructs them
# from the manifest. Safe to re-run: existing checkouts are fetched + fast-
# forwarded rather than re-cloned.
#
# Usage:
#   ./clone.sh                # clone/update every repo in repos.txt
#   ./clone.sh adk-java       # only the named repos
#   DEPTH=1 ./clone.sh        # shallow clones (faster; no full history)
#
set -euo pipefail

cd "$(dirname "$0")"
MANIFEST="repos.txt"
[ -f "$MANIFEST" ] || { echo "error: $MANIFEST not found" >&2; exit 1; }

DEPTH="${DEPTH:-}"
depth_args=()
[ -n "$DEPTH" ] && depth_args=(--depth "$DEPTH")

want=("$@")   # optional filter list

want_this() {
  [ ${#want[@]} -eq 0 ] && return 0
  for w in "${want[@]}"; do [ "$w" = "$1" ] && return 0; done
  return 1
}

fail=0
while read -r dir branch url; do
  case "$dir" in ''|\#*) continue ;; esac   # skip blanks/comments
  want_this "$dir" || continue

  if [ -d "$dir/.git" ]; then
    echo "==> updating $dir ($branch)"
    git -C "$dir" fetch --quiet origin "$branch"
    git -C "$dir" checkout --quiet "$branch"
    git -C "$dir" merge --ff-only --quiet "origin/$branch" || {
      echo "    ! $dir: local branch diverged from origin/$branch, skipping ff" >&2
      fail=1
    }
  else
    echo "==> cloning $dir <- $url ($branch)"
    git clone "${depth_args[@]}" --branch "$branch" "$url" "$dir" || fail=1
  fi
done < "$MANIFEST"

exit "$fail"
