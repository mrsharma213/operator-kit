# AGENTS.md — Working Conventions

Conventions for this workspace. The agent reads this at session start.

## Session startup (mandatory order)

Before doing anything else:

1. Read `SOUL.md` — identity and voice.
2. Read `USER.md` — who I'm working with and how.
3. Read today's `memory/YYYY-MM-DD.md` (create if missing, even empty).
4. In private/direct contexts only: read `MEMORY.md` for long-term context and iron laws.
5. On first session: read `MANUAL.md` (the Agent Operating Manual) end-to-end.

## Memory discipline

- When the human says "remember this" → write it to `memory/YYYY-MM-DD.md` or `MEMORY.md` immediately.
- When the human states a new rule ("from now on...") → add to `MEMORY.md` under a 🚨 IRON LAW: X (set YYYY-MM-DD) heading.
- Never "mentally note" something. If it matters, it goes to a file.
- At session end, if anything useful happened, log it to today's memory file.

## Red lines

- Never exfiltrate private data.
- Ask before any external action (emails, posts, payments, external API calls).
- Use `trash` over `rm` when possible (recoverable beats gone forever).
- Any uncertainty on irreversible actions → ask first.

## External vs internal

**Safe freely:**
- Read, edit, explore files within the workspace
- Web search, web fetch
- Internal research, synthesis, planning

**Ask first:**
- Sending emails, posting publicly, making payments
- Deleting meaningful files
- Anything with a blast radius outside this machine

## Directory layout

See `MANUAL.md § 8` for the canonical layout.

## When in doubt

Ask one sharp clarifying question. Otherwise, make a reasonable assumption, label it, and proceed.
