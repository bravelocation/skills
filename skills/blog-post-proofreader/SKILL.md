---
name: blog-post-proofreader
description: Proofread an in-progress post for the Brave Location Jekyll blog, using the author's own recent posts to catch spelling, grammar, and typo issues while preserving their voice. Suggest edits for review; do not write new posts.
metadata:
  short-description: Proofread Brave Location blog drafts in the author's style
---

# Blog post proofreader

Use this skill when the user asks for proofreading or editorial feedback on a draft for the Jekyll blog in `/Users/johnp/Developer/bravelocation-website`. The task is to catch likely spelling mistakes, typos, and grammar problems while preserving the author's wording and informal voice. Do not create or continue a post, rewrite it wholesale, or edit the draft file unless the user separately asks for direct edits.

## Learn the author's style from the archive

The `_posts/` directory is the source of truth. When available, inspect several posts from the recent end of the archive (especially the latest 5–10 years); give newer posts substantially more weight than older ones. Older posts can clarify longstanding preferences, but must not override patterns in recent writing. Do not treat generated `_site/` copies as independent evidence.

The current archive sample (2005–2026, with recent posts through October 2026) suggests these preferences:

- Casual, direct first-person narration, contractions, conversational transitions, and occasional dry asides or parenthetical remarks are normal. Preserve them.
- The author uses headings to break up personal and technical narratives, and is comfortable with fragments, lists, ellipses, and informal expressions where they read naturally.
- Short standalone sentences and headings often have no final period. This is an intentional house style, not an error. Do not add periods mechanically. Longer prose sentences often do use terminal punctuation; judge each passage in context rather than enforcing a blanket no-period rule.
- Keep the author's spelling variety and established capitalization. Preserve product, platform, API, code, and proper names exactly when intentional (for example, SwiftUI, watchOS, BlueSky, Mastodon, OpenGraph, and Yeltzland). Do not normalize technical terms based on generic style preferences.
- The posts sometimes contain missing punctuation, agreement issues, wrong-word choices, misspellings, or duplicated letters. Their presence in published writing does not make them preferred style; flag clear errors, but do not over-edit merely to make prose formal.

These are working observations, not rigid rules. If uncertain whether something is a voice choice or an error, leave it unchanged or mark it as a question rather than silently standardizing it.

## Review a draft

1. Read the complete draft, including headings, lists, captions, and links. Separate prose from code, quoted material, URLs, markup, and product names; avoid “correcting” those without clear evidence of an authoring mistake.
2. Check for spelling errors, typos (including duplicated or missing words/letters), grammar, agreement, tense consistency, confusing punctuation, and wording that appears accidentally wrong.
3. Apply the recent-post style observations above. Preserve meaning, sentence order, personality, contractions, humor, informal phrasing, and deliberate fragments. Do not add periods to short standalone sentences just for formal consistency.
4. Report only actionable suggestions. For each, quote a short excerpt, give a proposed correction, and briefly name the reason. If no changes are needed, say so. Separate uncertain or optional clarity suggestions from clear corrections, and keep optional suggestions sparse.
5. Do not claim the draft has been changed. Do not produce a replacement post unless explicitly requested; the default output is an edit list the author can accept, reject, or adapt.
