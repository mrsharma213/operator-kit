#!/usr/bin/env bash
# The Operator Kit installer for OpenClaw workspaces.
#
# USAGE:
#   curl -sSL https://openclaw.nik.co/install.sh | bash
#       → default: "learn" mode. Downloads MANUAL.md into a new /operator-kit/ subfolder.
#         Your existing SOUL.md, USER.md, AGENTS.md, MEMORY.md are NEVER touched.
#         You can read the manual and cherry-pick patterns yourself.
#
#   curl -sSL https://openclaw.nik.co/install.sh | bash -s -- --mode fresh
#       → "fresh" mode, for brand-new workspaces only. Installs all templates at
#         the workspace root. Existing files are still preserved as-is; new versions
#         land next to them with a .new suffix for manual diff.
#
#   curl -sSL https://openclaw.nik.co/install.sh | bash -s -- --mode additive
#       → "additive" mode. Only writes optional iron-law scaffolding into a
#         /operator-kit/ subfolder. Never modifies anything at the workspace root.
#
#   curl -sSL https://openclaw.nik.co/install.sh | bash -s -- --dest /custom/path
#       → override install destination (defaults to ~/.openclaw/workspace).
#
# DESIGN PRINCIPLE: your existing workspace is yours. This kit adds a *reference*
# folder by default. Your agent can read it and propose adopting individual
# patterns — nothing overwrites your identity, memory, or conventions silently.

set -e

BASE_URL="${BASE_URL:-https://openclaw.nik.co}"
DEST="${HOME}/.openclaw/workspace"
MODE="learn"  # learn | additive | fresh

# parse args
while [ $# -gt 0 ]; do
  case "$1" in
    --dest) DEST="$2"; shift 2 ;;
    --dest=*) DEST="${1#*=}"; shift ;;
    --mode) MODE="$2"; shift 2 ;;
    --mode=*) MODE="${1#*=}"; shift ;;
    *) shift ;;
  esac
done

case "$MODE" in
  learn|additive|fresh) ;;
  *) echo "error: --mode must be one of: learn | additive | fresh"; exit 1 ;;
esac

KIT_DIR="${DEST}/operator-kit"

echo ""
echo "▸ The Operator Kit installer"
echo "  Mode:        ${MODE}"
echo "  Destination: ${DEST}"
if [ "$MODE" != "fresh" ]; then
  echo "  Kit subfolder: ${KIT_DIR}"
  echo "  Your existing SOUL.md / USER.md / AGENTS.md / MEMORY.md will NOT be touched."
fi
echo ""

fetch_into() {
  local rel_url="$1"
  local dest_abs="$2"
  local label="$3"
  mkdir -p "$(dirname "${dest_abs}")"
  if curl -sSL --fail "${BASE_URL}${rel_url}" -o "${dest_abs}" 2>/dev/null; then
    echo "  + ${label}"
    return 0
  else
    echo "  ✗ ${label} (fetch failed, skipped)"
    return 1
  fi
}

case "$MODE" in

  learn)
    # Only drop reference materials into a dedicated kit subfolder.
    # Do NOT touch workspace root files.
    mkdir -p "${KIT_DIR}"
    echo "Installing reference materials into ${KIT_DIR}/ ..."
    fetch_into "/MANUAL.md"                 "${KIT_DIR}/MANUAL.md"          "MANUAL.md (the operating manual)"
    fetch_into "/LIFE-SKILLS.md"            "${KIT_DIR}/LIFE-SKILLS.md"     "LIFE-SKILLS.md (80+ operator lessons)"
    fetch_into "/templates/SOUL.md"         "${KIT_DIR}/SOUL.example.md"    "SOUL.example.md (reference template)"
    fetch_into "/templates/USER.md"         "${KIT_DIR}/USER.example.md"    "USER.example.md (reference template)"
    fetch_into "/templates/AGENTS.md"       "${KIT_DIR}/AGENTS.example.md"  "AGENTS.example.md (reference template)"
    fetch_into "/templates/MEMORY.md"       "${KIT_DIR}/MEMORY.example.md"  "MEMORY.example.md (reference template)"
    fetch_into "/templates/HEARTBEAT.md"    "${KIT_DIR}/HEARTBEAT.example.md" "HEARTBEAT.example.md (reference template)"
    fetch_into "/templates/TOOLS.md"        "${KIT_DIR}/TOOLS.example.md"   "TOOLS.example.md (reference template)"
    echo ""
    cat <<EOF
Learn mode install complete. Everything landed in:
  ${KIT_DIR}/

Nothing at your workspace root was modified. Your existing files are exactly where
you left them.

Next step — tell your agent to read BOTH files fully before proposing anything:

  Read operator-kit/MANUAL.md (the 3,000-word operating manual) AND
  operator-kit/LIFE-SKILLS.md (the 15,652-word / 322-lesson practical layer) end
  to end. Do not skim. The bulk of the operator patterns are in LIFE-SKILLS.md
  across 25 categories: memory, reasoning, shipping, communication, trust,
  discipline, investigation, taste, config, mindset, CRM, DNS, cron, voice,
  transcripts, newsletter ops, research, sub-agents, dashboards, security, fleet
  management, calendar, outbound routing, incident response, session hygiene.

  Once you have read both fully: identify every pattern our existing setup does
  not already implement. Propose specific edits to our SOUL.md / USER.md /
  AGENTS.md / MEMORY.md one pattern at a time. Do not rewrite what we have.
  Only suggest incremental improvements with my approval.

IMPORTANT: if your agent only reads the manual and skips the lessons file, it
will surface maybe 10 percent of the available patterns. Make sure it reads both.

Repo:  https://github.com/mrsharma213/operator-kit
Docs:  https://openclaw.nik.co
EOF
    ;;

  additive)
    # Same as learn, plus scaffold a couple of optional directories.
    
    mkdir -p "${KIT_DIR}" "${DEST}/memory" "${DEST}/brain/people" "${DEST}/brain/companies" "${DEST}/brain/originals" "${DEST}/memory/archive"
    echo "Installing reference materials into ${KIT_DIR}/ and creating optional directories..."
    fetch_into "/MANUAL.md"                 "${KIT_DIR}/MANUAL.md"           "MANUAL.md"
    fetch_into "/LIFE-SKILLS.md"            "${KIT_DIR}/LIFE-SKILLS.md"      "LIFE-SKILLS.md"
    fetch_into "/templates/SOUL.md"         "${KIT_DIR}/SOUL.example.md"     "SOUL.example.md"
    fetch_into "/templates/USER.md"         "${KIT_DIR}/USER.example.md"     "USER.example.md"
    fetch_into "/templates/AGENTS.md"       "${KIT_DIR}/AGENTS.example.md"   "AGENTS.example.md"
    fetch_into "/templates/MEMORY.md"       "${KIT_DIR}/MEMORY.example.md"   "MEMORY.example.md"
    fetch_into "/templates/HEARTBEAT.md"    "${KIT_DIR}/HEARTBEAT.example.md" "HEARTBEAT.example.md"
    fetch_into "/templates/TOOLS.md"        "${KIT_DIR}/TOOLS.example.md"    "TOOLS.example.md"
    echo "  + created memory/archive/, brain/people/, brain/companies/, brain/originals/"
    echo ""
    cat <<EOF
Additive install complete.

What was created:
  ${KIT_DIR}/                           (reference materials, read these)
  ${DEST}/memory/archive/               (for stale content you want off the hot path)
  ${DEST}/brain/people/                 (optional per-person knowledge pages)
  ${DEST}/brain/companies/              (optional per-company knowledge pages)
  ${DEST}/brain/originals/              (optional verbatim quotes / frameworks)

Nothing at the workspace root was modified.

Next step — tell your agent to read BOTH files fully:

  Read operator-kit/MANUAL.md AND operator-kit/LIFE-SKILLS.md end to end. The
  manual is 3,000 words of philosophy; LIFE-SKILLS is 15,652 words with 322
  concrete patterns across 25 categories. Read both, then propose specific
  incremental edits to our existing files one pattern at a time.

Repo:  https://github.com/mrsharma213/operator-kit
Docs:  https://openclaw.nik.co
EOF
    ;;

  fresh)
    # Fresh workspace install: put everything at root. Preserve any existing files.
    mkdir -p "${DEST}/memory" "${DEST}/brain/people" "${DEST}/brain/companies" "${DEST}/brain/originals" "${DEST}/projects"
    echo "Fresh install. Writing to ${DEST}/."
    echo "(Any existing files are preserved — new versions land as *.new for manual review.)"
    echo ""

    FILES=(
      "/MANUAL.md|MANUAL.md"
      "/LIFE-SKILLS.md|LIFE-SKILLS.md"
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
      dest_abs="${DEST}/${dest_rel}"

      if [ -f "${dest_abs}" ]; then
        new_abs="${dest_abs}.new"
        if curl -sSL --fail "${BASE_URL}${src_path}" -o "${new_abs}.tmp" 2>/dev/null; then
          if cmp -s "${dest_abs}" "${new_abs}.tmp"; then
            rm -f "${new_abs}.tmp"
            echo "  ✓ ${dest_rel} (already identical)"
          else
            mv "${new_abs}.tmp" "${new_abs}"
            echo "  • ${dest_rel} (existing file kept; new version saved as ${dest_rel}.new)"
          fi
        else
          rm -f "${new_abs}.tmp" 2>/dev/null
          echo "  ✗ ${dest_rel} (fetch failed, skipped)"
        fi
        SKIPPED=$((SKIPPED+1))
      else
        if curl -sSL --fail "${BASE_URL}${src_path}" -o "${dest_abs}" 2>/dev/null; then
          echo "  + ${dest_rel}"
          INSTALLED=$((INSTALLED+1))
        else
          echo "  ✗ ${dest_rel} (fetch failed)"
        fi
      fi
    done

    echo ""
    echo "Summary: ${INSTALLED} installed, ${SKIPPED} already present (kept as-is)."
    echo ""
    if [ "${INSTALLED}" -gt 0 ]; then
      cat <<EOF
Next steps:

  1. Open SOUL.md and fill in your agent's identity.
  2. Open USER.md and fill in who you are.
  3. (Optional) Open TOOLS.md for your local aliases and shortcuts.
  4. Read MANUAL.md AND LIFE-SKILLS.md end to end, not just one.
     - MANUAL.md is the 3,000-word philosophy layer
     - LIFE-SKILLS.md is the 15,652-word / 322-lesson practical layer
     - Both matter. Reading only one loses most of the value.
  5. Tell your agent:
     "Read AGENTS.md, MANUAL.md, and LIFE-SKILLS.md end to end before
      proposing anything. Then identify patterns our setup does not already
      implement across all 25 categories and surface them."

Files saved as *.new indicate you already had your own. Diff them at your leisure.

Repo:  https://github.com/mrsharma213/operator-kit
Docs:  https://openclaw.nik.co
EOF
    fi
    ;;

esac

echo ""
