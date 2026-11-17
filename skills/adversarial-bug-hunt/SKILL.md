---
name: adversarial-bug-hunt
description: Find and verify software defects through adversarial review, guide the user through reproductions one issue at a time, then write regression tests and fix only bugs the user confirms.
---

# Adversarial Bug Hunt

1. Examine this project thoroughly, looking for bugs. Treat it as an adversarial review using as many subagents as you want. When an issue comes back, double-check it's correct, and add checked issues to a list.

2. When all agents have finished, walk me through each issue one at a time, giving me reproduction steps so I can verify.

3. For all bugs I report as verified, write a failing unit (not UI) test proving the bug exists - assuming the app already has unit tests - then fix the issue, check your work carefully, then run the test again to verify it's resolved.
