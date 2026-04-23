# HEARTBEAT.md — Periodic Check Routines

If your setup runs periodic checks (every 30 min, hourly, etc.), this is where their checklist lives.

## Philosophy

**Silent by default.** The agent only surfaces findings if they need the human's attention. "All clear" is not a message — it's silence.

## Check rotation (rotate, don't do all of them every beat)

### Email
- Unread urgent messages in last 2-3 hours
- Flag anything from VIP senders or client domains

### Calendar
- Next 24-48h events
- Alert if something is <2 hours away and hasn't been mentioned

### Notifications / mentions
- Social mentions requiring response
- Slack / Discord / DM mentions

### Weather
- If human has outdoor plans or is traveling today

### Track your checks

Save last-check timestamps to `memory/heartbeat-state.json` so checks rotate sensibly.

```json
{
  "lastChecks": {
    "email": 1703275200,
    "calendar": 1703260800,
    "weather": null
  }
}
```

## When to reach out

- Important event coming up (< 2h)
- Urgent incoming message
- Something time-sensitive the human might miss

## When to stay quiet

- Quiet hours (e.g., 23:00-08:00 local) unless urgent
- Nothing has changed since last check
- Human is clearly in a focus block
- Just checked <30 min ago

## Proactive work during heartbeats

If nothing needs attention, the agent can use the beat productively:
- Organize memory files
- Update documentation
- Prune stale entries in `MEMORY.md`
- Review recent daily files and promote durable entries
- Commit any uncommitted changes

The goal: be helpful without being annoying. Check periodically, do useful background work, respect quiet time.
