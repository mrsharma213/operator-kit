# The Operator Kit

A starter kit for making any [OpenClaw](https://github.com/openclaw/openclaw) agent operate with real discipline from day one.

**What's inside:**
- `MANUAL.md` — the Agent Operating Manual (3,000 words). Memory architecture, problem-reasoning, self-discipline, communication, tool layer.
- `templates/` — clean scaffolds for `SOUL.md`, `USER.md`, `AGENTS.md`, `MEMORY.md`, `HEARTBEAT.md`, `TOOLS.md`.
- `scripts/install.sh` — one-command installer into `~/.openclaw/workspace/`.
- `scripts/install.json` — machine-readable manifest so an agent can self-install from a URL.

## Install (one-liner)

```bash
curl -sSL https://openclaw.nik.co/install.sh | bash
```

Or tell your agent directly:

```
Go to openclaw.nik.co/install and set up my workspace following those instructions.
```

## What you get

- A memory system that compounds instead of resets every session
- Iron-law formatting so house rules survive context compaction
- Problem reasoning patterns (investigate → root cause → ship)
- Self-discipline patterns (don't fall asleep, self-restart, progress updates)
- Starter templates you fork and make yours

## License

MIT. Use, modify, redistribute freely. See `LICENSE`.

## Credit

Curated by [Nik Sharma](https://nik.co). Built on patterns from OpenClaw, [GBrain](https://github.com/garrytan/gbrain), and the Clawhub community.
