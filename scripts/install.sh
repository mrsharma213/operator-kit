#!/usr/bin/env bash
# Operator Kit installer for OpenClaw workspaces.
# Usage:
#   curl -sSL https://openclaw.nik.co/install.sh | bash
#   curl -sSL https://openclaw.nik.co/install.sh | bash -s -- --dest /custom/path
#
# Safe by default: never overwrites an existing file. If a file already exists at
# the destination, it's kept and the new one is written as <file>.new for manual review.

set -e

BASE_URL="${BASE_URL:-https://openclaw.nik.co}"
DEST="${HOME}/.openclaw/workspace"

# parse optional --dest flag
while [ $# -gt 0 ]; do
  case "$1" in
    --dest) DEST="$2"; shift 2 ;;
    --dest=*) DEST="${1#*=}"; shift ;;
    *) shift ;;
  esac
done

echo ""
echo "▸ Operator Kit installer"
echo "  Destination: ${DEST}"
echo ""

mkdir -p "${DEST}/memory" "${DEST}/brain/people" "${DEST}/brain/companies" "${DEST}/brain/originals" "${DEST}/projects"

# Files to install: <source_path>|<dest_relative_path>
FILES=(
  "/MANUAL.md|MANUAL.md"
  "/templates/SOUL.md|SOUL.md"
  "/templates/USER.md|USER.md"
  "/templates/AGENTS.md|AGENTS.md"
  "/templates/MEMORY.md|MEMORY.md"
  "/templates/HEARTBEAT.md|HEARTBEAT.md"
  "/templates/TOOLS.md|TOOLS.md"
)

INSTALLED=0
SKIPPED=0

for entry in "${FILES[@]}"; do
  src_path="${entry%%|*}"
  dest_rel="${entry#*|}"
  src_url="${BASE_URL}${src_path}"
  dest_abs="${DEST}/${dest_rel}"

  if [ -f "${dest_abs}" ]; then
    # preserve existing; save new copy side-by-side for review
    new_abs="${dest_abs}.new"
    if curl -sSL --fail "${src_url}" -o "${new_abs}.tmp" 2>/dev/null; then
      if cmp -s "${dest_abs}" "${new_abs}.tmp"; then
        rm -f "${new_abs}.tmp"
        echo "  ✓ ${dest_rel} (already identical)"
      else
        mv "${new_abs}.tmp" "${new_abs}"
        echo "  • ${dest_rel} (kept existing, new version saved as ${dest_rel}.new)"
      fi
    else
      rm -f "${new_abs}.tmp"
      echo "  ✗ ${dest_rel} (fetch failed, skipped)"
    fi
    SKIPPED=$((SKIPPED+1))
  else
    if curl -sSL --fail "${src_url}" -o "${dest_abs}" 2>/dev/null; then
      echo "  + ${dest_rel}"
      INSTALLED=$((INSTALLED+1))
    else
      echo "  ✗ ${dest_rel} (fetch failed)"
    fi
  fi
done

echo ""
echo "Summary: ${INSTALLED} installed, ${SKIPPED} already present."
echo ""

if [ "${INSTALLED}" -gt 0 ]; then
  cat <<'EOF'
Next steps:

  1. Open SOUL.md and fill in your agent's identity.
  2. Open USER.md and fill in who you are.
  3. (Optional) Open TOOLS.md for your local aliases and shortcuts.
  4. Read MANUAL.md at least once — it's the operating philosophy.
  5. Tell your agent: "Read AGENTS.md and MANUAL.md and follow them."

Files saved as *.new indicate you already had your own. Diff them at your leisure.

Repo: https://github.com/mrsharma213/operator-kit
Docs: https://openclaw.nik.co
EOF
fi

echo ""
