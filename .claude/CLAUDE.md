# CLAUDE.md — Engineering Standards

## Core Principles
- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact**: Changes should only touch what's necessary. Avoid introducing bugs.
- **Security Mindset**: Before submitting any change, ask: "Does this introduce a vulnerability?" (injection, auth bypass, exposed secrets, unvalidated input at system boundaries).
- **Document the Why**: Non-obvious architectural decisions must have rationale captured — inline, in task notes, or in the relevant doc. Tracking *what* was done is not enough.

---

## Workflow

### Step 1 — Clarify Before Planning
Surface ambiguity *before* planning, not during. If intent is unclear, ask one focused question and wait. Never plan against an assumption you could verify.

### Step 2 — Read Before Touching
Understand before modifying. Read the relevant code, identify existing patterns and utilities to reuse. Never modify code you haven't read. Propose reuse before writing new abstractions.

### Step 3 — Docs First (Before Code Changes)
For any non-trivial change, update documentation *before* touching implementation:
1. **Update docs first** — reflect the intended behavior, architecture, or API contract. If docs don't exist, write them. This forces clarity on the interface before implementation begins.
2. **Update or write tests second** — tests should verify the documented behavior. If a test can't be written, the spec isn't clear enough yet.
3. **Write the code third** — implement against the documented spec and passing tests.
4. **Commit only when all three are aligned** — docs, tests, and code must be consistent before a commit is made.

This disciplines the order: architecture is decided in docs, behavior is pinned in tests, code follows.

### Step 4 — Plan (Non-Trivial Tasks)
- Enter plan mode for ANY task with 3+ steps or architectural decisions
- Write the plan to `tasks/todo.md` with checkable items
- Check in with the user before starting implementation
- If something goes sideways: STOP, re-plan, don't keep pushing
  - "Going sideways" = two failed attempts at the same fix, expanding scope, or hitting an unexpected dependency

### Step 5 — Implement
- Track progress by marking items complete in `tasks/todo.md`
- Provide a high-level summary at each meaningful step
- Add a review/results section to `tasks/todo.md` when done

### Step 6 — Verify Before Done
- Never mark a task complete without proving it works
- Definition of done: runs cleanly in CI, tested against stated requirements, no obvious regressions, docs and tests are consistent with code
- Diff behavior between main and your changes when relevant
- Ask: "Would a staff engineer approve this PR?"

### Step 7 — Capture Lessons
- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write a rule that prevents the same mistake from recurring
- Review `tasks/lessons.md` at session start for the relevant project

---

## Subagent Strategy
- Use subagents liberally to keep the main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One focused task per subagent — avoid multi-purpose agents

---

## Autonomy Threshold

**Proceed autonomously when:**
- The problem is well-defined and unambiguous
- The change is reversible
- Scope is contained within the original request

**Ask before proceeding when:**
- Requirements or intent are ambiguous
- The change is irreversible (see Safety Protocol below)
- Scope has expanded beyond the original request
- You've failed at the same approach twice

The "Autonomous Bug Fixing" default is: given a bug report with logs/errors/failing tests — diagnose and fix without hand-holding. But if the root cause is unclear after investigation, surface the uncertainty rather than guess.

---

## Safety Protocol
Before any destructive or irreversible action — force-push, data deletion, schema changes, CI/CD modification, overwriting uncommitted work — explicitly state what you're about to do and confirm with the user. Reversible local changes can proceed autonomously.

---

## Debugging Methodology
When given a bug report:
1. **Reproduce** — confirm you can trigger the failure
2. **Isolate** — narrow to the smallest failing case
3. **Hypothesize** — form a specific, testable theory about the cause
4. **Verify the fix** — confirm the hypothesis was correct, not just that symptoms disappeared
5. **Check for regressions** — run the full test suite, not just the affected test
6. **Update docs/tests if behavior changed** — a bug fix that changes behavior is a spec change

---

## Elegance Check (Non-Trivial Changes)
- Pause and ask: "Is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip for simple, obvious fixes — don't over-engineer
- Challenge your own work before presenting it
