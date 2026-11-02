---
name: "english-academic-style"
description: "사용자의 영문 학술 문체 규범(humanizer의 Wikipedia AI-writing 목록을 흡수한 판). 영어 논문·학회 원고·기술 보고서·연구 노트를 쓰거나 고칠 때, 또는 \"make it sound human\", \"remove the AI tell\", \"polish for submission\", \"humanize\" 같은 요청이 있을 때 반드시 이 스킬을 따른다. 영어로 된 격식 있는 글(abstract, introduction, related work, conclusion, rebuttal, proposal)을 생성·수정·검토하는 모든 작업에 적용한다. 사용자가 문체를 언급하지 않아도 영문 학술·기술 문서를 다루는 순간 적용한다."
---

# English Academic Style Guide

This skill is the English counterpart of the author's Korean academic style guide, rebuilt around English-specific AI fingerprints. The goal is the same: **plain academic prose that reads as human-written and is understood in a single pass**. Most rules below list "things AI writes constantly but careful human authors rarely do." The list absorbs the academic-relevant part of Wikipedia's "Signs of AI writing" (via the humanizer skill); the blog, sales, and chatbot-residue patterns of that list are left out because they do not occur in manuscripts.

Why the patterns exist: a model writes what is most likely next, so by default it chooses what fits the widest range of readers. A human author chooses for one reader and one subject. Every tell below is one form of the default choice. Two rules follow. Every sentence kept must add something the reader did not already have. A tell counts in proportion to how rarely a careful writer would make it on purpose (Section 6 grades them).

## 1. Sentence texture

**No AI emphasis formulas.** Delete lead-in scaffolding such as "The key insight is that...", "It is worth noting that...", "Importantly," "Notably," "Crucially," "What makes this significant is...". If something deserves emphasis, restructure the sentence so the content itself comes first.

- Bad: "The key insight is that the improvement does not depend on the regime." → Good: "The improvement depends little on the regime."
- Bad: "It is worth noting that prior work assumes synchrony." → Good: "Prior work assumes synchrony."

**No staged run-up before the point.** "In what follows we show", "Here it is important to understand", "Let us now turn to" announce the point instead of making it. Remove the run-up, not just its tone.

**No punch-then-elaborate rhythm and no aphoristic closers.** Short declarative punches followed by elaboration, and paragraphs that end on an epigram ("That is all the protocol needs." / "Nothing else survives."), are essay rhythm, not paper rhythm. So is a one-sentence paragraph that restates the paragraph before it, and a row of fragments ("No prior. No history. No tuning."). State the claim as a full academic sentence and support it. One short sentence may carry emphasis when it carries a new fact.

**No sayings that sound deep.** "The real question is", "at its core", "fundamentally", "the heart of the matter", "X is the currency of Y" dress an ordinary point as a hidden truth. Replace the saying with the specific claim.

**No formulaic parallelism.** Triadic lists used as filler ("fast, scalable, and robust"), "not only X but also Y" as a default connector (an occasional one is ordinary; published papers use it up to about three times per 10,000 words), and "not X but Y" contrast framing repeated across paragraphs are AI fingerprints. The contrast has variants that count the same: "X rather than Y" used only for weight, the contrast split across two sentences ("This does not mean X. It means Y."), and a clipped negative tail ("..., no tuning required"). The negative half usually names something no one claimed. Keep a contrast only when the negative half corrects a belief the reader actually holds, or when both halves carry information. Check that each item of a triad adds a distinct idea; merge or develop the strongest one when they do not.

**No arguing with no one.** "One might be tempted to", "A tempting approach would be", "To be clear", "This is not to say", "Don't get me wrong", "Some might argue" answer an objection that appears nowhere else, usually a leftover from an earlier draft. Remove the defense; if it holds a real claim, state the claim. Exception that matters in a manuscript: an objection a reviewer actually raised, or an alternative a reader would actually weigh, stays, stated in full and answered in full (the paper-framing skill's rule on preserving review responses applies).

**No repeated sentence openings.** Several sentences in a row starting with the same subject ("We propose... We show... We evaluate...") come from handling repetition by rule. Merge, change the subject, or begin with the action. Do not ban the repeated word; a remaining sentence may still start with "We".

**Prefer verbs over nominalizations.** "We measure the latency" instead of "the measurement of latency is performed". Chains of abstract nouns ("the implementation of the evaluation of...") must be unwound into clauses with agents and verbs. Describing the setup with "experiments were performed on" is ordinary; keep "is performed/conducted/carried out" to about three per 10,000 words.

**Passive voice: use it deliberately, not by default.** Passive is acceptable when the agent is unknown, irrelevant, or fixed by convention ("the dataset was collected in 2024"). Well-written published papers put roughly 12 to 42 percent of their sentences in the passive, so do not convert passives just to lower the count. A passive with a "by" agent is fine when the sentence is about the thing acted on; keep such sentences to about eight per 100. Write active when the agent is the topic ("several studies have reported this threat", not "this threat has been reported in several studies"). When converting passive to active, never strengthen the claim: "no evidence was found" may become "we found no evidence", never "there is no evidence".

**One hedge per claim, at most.** Stacked hedges ("may potentially suggest", "could possibly indicate") are an AI tell. Pick one hedge that matches the actual epistemic state and delete the rest. Do not remove a hedge the claim needs. Ordinary hedges such as "perhaps" or "tends to" are human habits, not tells. Published papers use about three to six hedges per 1,000 words; a draft with almost none reads as overclaiming, so never edit only in the direction of fewer hedges.

## 2. Vocabulary

**Use the words readers already know.** For each meaning, use the word that ordinary papers in the field use most: use, show, need, because, before, and not utilize, demonstrate, necessitate, owing to the fact that, prior to. If a word could send a non-native reader to a dictionary, replace it with a plainer one, unless it is an established technical term of the field. The test is not whether the word is correct but whether the intended reviewer reads past it without noticing it.

**Use is, are, and has.** "serves as", "stands as", "functions as", "represents", "features", "boasts", "offers" replace a simple verb with a longer phrase. "Table 2 is the main result", not "Table 2 serves as the main result". "X refers to Y" in a definition is ordinary and stays.

**Replace figurative and literary phrasing with the literal statement.** Metaphor, personification, and borrowed idiom read as authorial flourish once, and as affectation the second time. "The value of waiting is not in the rule's vocabulary" becomes "the rule cannot wait, so it recovers none of that value"; "the home of waiting" becomes "the environment where waiting pays"; "two faces of one identity" becomes "two consequences of the same identity". Keep a figure of speech only when it is standard usage in the field (a "wall" in "speed wall" that the paper itself defines is notation, not metaphor).

**Ban the AI lexicon.** The following words and phrases are near-certain fingerprints when used as filler; replace them with plain equivalents or delete: delve, leverage (for "use"), utilize (for "use"), showcase, underscore (verb), "highlights" (verb), harness, foster, fostering, bolster, bolstered, enhance, myriad, plethora, holistic, seamless, pivotal, valuable, enduring, meticulous, meticulously, intricate, intricacies, interplay, vibrant, quietly, garner, align with, additionally, actually, emphasizing, game-changer, paradigm shift, "in the realm of", "the landscape of", landscape (abstract noun), tapestry, "a testament to", "plays a crucial/vital/key role", "rich tapestry", gate/gated/gating (figurative). Keep a word only if it is an established technical term in the field (e.g., "robust" in "robust statistics" stays; "a robust framework" goes; "gate" as a protocol step stays). A formal word outside this list is not a tell by itself.

- "utilize" → "use" / "facilitate" → "help" or "enable"

**Words that published papers use, with a ceiling.** Calibrated against well-written published papers (Section 7), these are ordinary in moderation and are not tells below the ceiling: "demonstrate" (about three per 10,000 words), adjective "key" as in "key differences" (about two; "the key insight is" stays banned as an emphasis formula), "note that", and "crucial", "notably", "comprehensive", "robust", and verb "highlight" (about one each). Above the ceiling, replace the extra uses.

**No inflated significance.** "marks a shift", "sets the stage for", "plays a key role", "underscores the importance", "reflects a broader", "lasting impact", and the stock send-off ("opens promising avenues", "we believe this is a step toward") say an ordinary result matters instead of saying what it is. Keep the fact and drop the significance. A future-work paragraph names the specific next experiment or extension, or is cut; it does not end on a hopeful sentence.

**No shallow -ing riders.** "..., highlighting the importance of", "..., underscoring", "..., ensuring", "..., reflecting", "..., contributing to" bolt a claim onto a fact to make it sound deeper. Keep the fact; keep the rider only when the paper's own evidence supports what it claims.

**Name the relationship, in related work above all.** "is associated with", "is related to", "is connected to", "builds on" without saying how hide whether the cited work is a special case, a competitor, a tool used, or a contradiction. Say which. If the relation is not known, do not invent one.

**No borrowed authority.** "prior work has shown", "it is well known", "researchers argue", "studies suggest" without a citation prop up a claim with an unnamed source. In a manuscript every such sentence carries a citation or is rewritten as the paper's own claim. Never invent a citation, a number, or a quotation; if the source is missing, ask for it or write a simpler sentence.

**Follow venue conventions, which differ from Korean ones.** First person "we" is standard in most CS, engineering, and science venues; use it for actions the authors took ("we prove", "we evaluate"). Use "this paper" for the artifact itself ("this paper makes three contributions"). Do not self-refer as "the authors". Section headings are noun phrases, not questions. Check the target venue if unsure; some journals still mandate impersonal style.

**One term per concept.** Pick one term for each concept and use it throughout; do not rotate synonyms for variety ("approach/method/technique/scheme" for the same thing). Expand abbreviations at first use: "full term (ABBR)", then use the abbreviation consistently.

## 3. Symbols and numbers

**No stray symbols in prose.** The em dash (—) is the single most recognizable AI fingerprint in English prose; do not use it. Replace with a comma, parentheses, a colon, or a sentence break. This includes spaced dashes and double hyphens (` -- `) used as dashes. Use the en dash only for numeric ranges. Never put →, ≈, ≠, or interpuncts in running text. Exceptions: math environments, tables, reference page ranges, code, paths, and fixed technical notation (e.g., unsafe→safe→finalized).

**No excess quantification.** The test for every number: "does the claim become weaker or unverifiable without it?" If not, qualify it in words or drop it. When restating a number qualitatively, verify the restatement against the original (25.8–29.9% → "over a quarter" is true, "nearly a third" is false). Sample sizes, p-values, and default-parameter dumps usually go. Spell out one-shot Greek symbols in words; keep only symbols that later sentences keep referencing (state variables and the like).

**Hyphenated pairs.** Keep the hyphen before a noun when grammar needs it ("a high-quality estimate") and drop it after the noun ("the estimate is high quality"). Fixed technical compounds keep their conventional spelling.

## 4. Flow and structure

- **Topic sentence first, as a default.** Put the paragraph's claim or task in its first sentence when you can; about half of the paragraphs in well-written published papers do. If the conclusion dangles at the paragraph's end, pull it to the front. Do not open a results paragraph with a sentence that only points to a table ("Table 3 shows the results."); state the result and cite the table in parentheses. Reading only the first sentences of every paragraph should give the gist of the argument.
- **Keep evidence close to the claim.** The support for a claim (a number, a table or figure, a theorem, a citation) belongs in the same paragraph or the table or figure next to it. A claim whose only support is several sections away should be moved or given a pointer.
- One sentence at the start of a section saying what it does ("In this section, we ...") is ordinary in published papers and may stay. Refer back with a section number ("as shown in Section 4"); keep unnumbered back-references ("as mentioned above") to about two per 10,000 words.
- **Connect by content, not connectives.** Chains of "Moreover, ... Furthermore, ... Additionally, ..." are an AI fingerprint. Open each paragraph and section by picking up the substance of what precedes it; delete the transition word if the content already carries the link.
- One idea per paragraph. Split sentences with nested parentheticals or multiple assumptions compressed into one clause ("We make four assumptions. First, ...").
- Delete throat-clearing: a first sentence that repeats the heading word for word, repeated limitation confessions (collect them in one place), restatements of earlier sections, and modifiers the argument survives without.
- **Describe the current version, not the previous one.** "Unlike our earlier formulation", "we no longer assume", "this replaces the previous approach" describe the draft history, which the reader never saw. State the current behavior. Change history belongs in a response letter or change log.
- **No bold labels or decorated lists.** Contribution lists with a bold label and a colon on every item ("**Efficiency:** ...") are formatting by rule. Write the contributions as prose or as a plain enumeration. Title Case headings are not a tell; headings follow the venue's template.
- **Vary sentence length the way careful human prose does.** Published papers average 18 to 24 words per sentence with a standard deviation of 9 to 15 words. Let a short sentence state a result and a longer one carry the qualification. Uniform sentence length is an AI tell, but do not manufacture choppiness to compensate; the variation must follow the content.
- A sentence that must be reread to be understood has failed. Rewrite it.

## 5. Edit the style, preserve the facts

When fixing style, technical claims, the meaning of numbers, citation numbers and attributions, and the scope of assumptions and limitations must not change by a single word. Watch especially:

- Rearranging sentences can **manufacture claims absent from the original** (attaching "the figure is only illustrative" to the previous sentence can turn it into "the figure illustrates that case"). Diff against the original after editing.
- Strict inequalities collapse in paraphrase ("less than half" ≠ "no more than half"). Preserve the exact strength of every mathematical condition.
- Batch replacements break agreement ("a NDA", "this approaches"). After any global substitution, recheck articles (a/an), subject–verb agreement, and singular/plural.
- Replacing a figurative phrase with a literal one (Section 2) must not sharpen or soften the claim it carried; restate exactly what the metaphor asserted, no more.
- Shape edits (merging a triad, cutting a closer, turning a labeled list into prose) drop facts most often. After each, list what the original said and check every item survives.
- Never add a fact, name, number, date, quote, or citation that is not in the source or supplied by the author. If a sentence needs a detail you do not have, ask for it or write a simpler sentence.

## 6. How strong a tell is, and when not to act

Act on one sighting for the staging patterns of Section 1: emphasis formulas, run-ups, closers and aphorisms, not-X-but-Y and its variants, arguing with no one, and for em dashes in a manuscript. These are almost never made on purpose by a careful academic writer.

Treat the following as *weak alone*, to be fixed only when other tells share the passage: a single hedge, a passive sentence, a hyphenated pair, a repeated opening, one "however". A person may do any of these on purpose.

Leave a watched phrase alone inside a quotation, a title, a proper name, defined notation, or a passage that discusses the phrase rather than uses it. Reviewer-raised objections and their answers stay (Section 1). Text the author wrote before working with a model is not a tell by definition; if the author supplies a sample of their own accepted papers, match its sentence length, word choice, and punctuation, and let the sample override the rules above where they conflict.

## 7. Calibration against published papers

The rules above are checked against a reference sample of well-written published papers in the field (top journals and award-winning conference papers). When a rule here and the sample disagree, the sample wins, except for the deliberate rules below. A draft should sit inside the sample's middle range (25th to 75th percentile); only values outside the 10th to 90th percentile need fixing. Aim to read like the sample, not cleaner than it: deleting every expression the sample uses also makes a text unlike the sample.

| Measure | Middle range in the sample |
|---|---|
| Sentence length, mean | 18 to 24 words (standard deviation 9 to 15) |
| Passive sentences | 12 to 42 percent |
| Hedges | 2.7 to 6.9 per 1,000 words |
| Sentence-initial connectives (However, Thus) | 6 to 10 per 100 sentences |
| Colons | 3 to 7 per 1,000 words |
| Sentences with two or more parentheticals | 9 or fewer per 100 sentences |
| Qualifications (conditions and caveats) per sentence | 0.15 or fewer |
| "we, our, us" | 4 to 19 per 1,000 words; "we" is normal |

Deliberate rules, kept although many published papers break them, because reviewers count them against a paper: no em dashes in a manuscript (Section 3), and claims in the abstract and conclusion no broader than the evidence in the body (the paper-framing skill). If the project keeps its own reference sample and measurement script, use its numbers instead of this table.

## Procedure

1. **Mark.** Read the whole text once, collecting violations of Sections 1–4 in order, strongest first (Section 6). Look at paragraph shape as well as sentences: a contrast split across sentences, three parallel examples, or the same closer after every section is the same tell at a larger scale. Flag figurative phrasing and dictionary-grade vocabulary alongside the fingerprints.
2. **Draft.** Fix sentence by sentence, checking each edit against Section 5 (facts invariant). When a sentence stays awkward, rewrite the paragraph around its main point rather than patching phrases.
3. **Check.** Read the draft once more and search for the five tells that most often survive a rewrite: a not-X-but-Y contrast, a one-line closer, a dash, a triad, a bold label. Then ask whether the rewrite added or dropped any fact, number, citation, or condition. Treat either as an error.
4. For length-limited documents (page limits), re-verify length after editing; unwinding nominalizations lengthens text, so offset with deletions of filler and repetition.
5. Finish with a mechanical sweep for banned symbols (—, --, →, ≈, ≠) and banned patterns (the Section 2 lexicon, "It is worth noting", "the authors" as self-reference, stacked hedges, "serves as", "is associated with", uncited "prior work has shown").