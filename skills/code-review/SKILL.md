---
name: code-review
description: Review a branch, staged or unstaged changes, or pull request before commit. Find only actionable defects introduced by the change, verify each finding against code and diff context, and report concise, evidence-backed results without modifying files.
---

# Code Review

Perform a rigorous review of the requested change. The goal is to identify defects that could affect users, data, security, reliability, compatibility, or maintainability in a concrete way. Favor a small number of well-supported findings over speculative or stylistic comments. Review only; do not edit files, stage changes, commit, push, or open/update a pull request.

## 1. Establish the review target

- Determine what the user means by the change: a PR, branch, staged diff, unstaged working tree, commit, or a combination. If the target is clear from context, proceed without asking.
- Inspect repository instructions first (`AGENTS.md`, contributing guidance, relevant local instructions) and obey them.
- Check the working tree and branch state before interpreting diffs. Preserve and account for the user's uncommitted work; never assume all local changes belong to the branch under review.
- For a PR or branch, identify the correct merge base with its target branch and review the full merge-base-to-head change. Do not rely only on the most recent commit or a possibly stale upstream tracking ref. Use available PR metadata/hosting tools when the user identifies a PR; otherwise use local Git data and state any limitation.
- For staged or unstaged review, inspect the requested diff (`--cached` for staged changes) and relevant untracked files. Do not silently broaden or narrow the requested scope.
- Read the complete diff, then inspect surrounding code, callers, callees, types, tests, configuration, and history as needed to understand behavior. A diff is evidence of what changed, not enough context by itself.

## 2. Review systematically

Trace changed behavior through its real call paths and check the applicable dimensions. Focus on risks relevant to the code rather than mechanically listing every category:

- Correctness: boundary conditions, state transitions, ordering, concurrency, async cancellation, retries, error handling, nil/empty values, time zones, numeric overflow, and assumptions about inputs.
- Data and persistence: migration compatibility, data loss/corruption, transaction boundaries, cache invalidation, serialization, and old/new version interoperability.
- Security and privacy: authorization at the point of use, trust boundaries, validation, injection, secrets, sensitive data exposure, insecure defaults, and unintended logging.
- API and compatibility: call-site behavior, public contracts, platform/runtime versions, schema changes, feature flags, and backward compatibility.
- Reliability and operations: resource cleanup, lifecycle, hangs, crashes, partial failures, configuration, observability needed for recovery, and performance regressions with a plausible impact.
- Tests: whether existing tests actually cover changed behavior and whether the change leaves a meaningful regression path untested. A missing test alone is not a finding unless it leaves a concrete, important defect likely or the repository requires that coverage.

Follow important values from input to side effect. Check both success and failure paths. For UI or framework code, inspect lifecycle and state ownership. For concurrency, reason about actor/thread boundaries and reentrancy. For security-sensitive code, verify checks happen server-side or at the authoritative boundary, not only in presentation code.

## 3. Verify every candidate finding

Before reporting an issue:

1. Confirm the behavior is caused by the reviewed change, not a pre-existing issue or unrelated cleanup.
2. Re-read the exact changed lines and enough surrounding code to validate the execution path.
3. Work through a concrete triggering scenario, including relevant inputs/state and resulting bad outcome. Use a focused existing test, static analysis, or a safe, targeted command when useful and proportionate; do not make changes to run the check.
4. Check whether another guard, invariant, caller constraint, or platform behavior prevents the scenario.
5. If the claim depends on an uncertain assumption, investigate it. If it remains uncertain, omit it or clearly mark the limitation rather than presenting it as fact.

Do not report hypothetical risks without a plausible trigger and impact. Do not report style, naming, formatting, refactoring preferences, or a possible future improvement as a defect. Avoid duplicate findings: combine symptoms caused by the same root cause. Do not claim a test, build, or tool was run unless it actually was.

Do not run the full test suite, build, benchmarks, or destructive commands by default. Run checks only when the user asks for verification or a small, targeted check is needed to establish a candidate finding. Respect repository guidance and avoid network access or operations that alter shared/external state unless explicitly authorized.

## 4. Rank and locate findings

Report only findings that an author could act on. Order by severity, then confidence:

- **P0 – Blocker:** Critical widespread impact, such as a severe security breach or unrecoverable data loss; blocks release/merge.
- **P1 – High:** Major user-facing failure, serious security issue, or likely data corruption affecting an important path; should be fixed before merge.
- **P2 – Medium:** A real defect with limited scope, a workaround, or a less common trigger; should be fixed, but need not block all work.
- **P3 – Low:** Small impact defect that is still concrete and worth fixing. Use sparingly.

Use the repository or host's required severity convention if one exists. Do not inflate priority to emphasize a finding. Include a confidence estimate (high/medium) only when it helps convey meaningful uncertainty; omit low-confidence speculation.

Each finding must:

- Point to the smallest changed line range that exposes the defect. Use current-file line numbers and ensure the range overlaps the diff. If a defect is only clear from broader context, anchor it on the changed line that introduces it.
- State the condition that triggers the bug and the concrete consequence. Explain why the existing behavior is wrong, not merely that code could be improved.
- Be concise and self-contained. Avoid broad prescriptions when a specific correction is apparent.

## 5. Report the result

If findings exist, lead with them in a standard review format:

```text
[P1] Preserve the existing account when refresh fails — Sources/Auth/Session.swift:42

When the token endpoint returns a transient error, this branch clears the stored session before the retry can run. Users are signed out on a recoverable network failure. Keep the old session until refresh succeeds.
```

Use one finding per item. Include a brief verification note only if it clarifies the evidence (for example, a targeted test result). Do not include long summaries ahead of actionable findings.

If no actionable defects are found, say: **No actionable findings.** Then briefly state what was reviewed and any material limitation (for example, the PR target branch could not be resolved, or tests were not run). A clean review is not a guarantee that the change is defect-free.

When the user requests an overall summary or asks questions beyond findings, add a short summary after the findings. Otherwise, keep the response focused on findings and relevant review limitations.
