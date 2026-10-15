# research-ops (English summary)

[![version](https://img.shields.io/badge/version-0.8.1-informational)](CHANGELOG.md)
[![code: MIT](https://img.shields.io/badge/code-MIT-blue)](LICENSE)
[![docs: CC BY 4.0](https://img.shields.io/badge/docs-CC%20BY%204.0-lightgrey)](LICENSE-docs)

research-ops is a set of procedures, templates, skills, and a project scaffold for running research with several LLM agents while keeping their numbers and judgments checkable. It targets Claude Code and Codex. The documents and skills are written in Korean; this page summarizes them for readers who do not read Korean. An AI tool given the repository URL reads `AGENTS.md` and can explain the rest in your language.

## What it enforces

The user decides and reviews. Agents search, implement, and check each other.

```
  User (daytime)                                 Agents (night, meetings, weekends)

  lock the problem statement  --+
  seal the decision rules       +-- hand-off order -->  search, implement, compute
  pick tasks and stop lines   --+                              |
                                                               v
                                                     a second agent recomputes
                                                     (no agent grades its own work)
                                                               |
  merge only what you accept  <-- review document ---  open choices are left
  answer pending decisions                             to the user, not guessed
```

Files and procedures keep three conditions:

1. Decision rules are written and hashed before results exist, and do not change after the results are seen.
2. The agent that produced a result does not check it. A fresh agent, given only the rules and the raw data, recomputes it.
3. "Not found" is kept apart from "does not exist". A literature search records its queries and the papers it could not open.

## What the demo shows

`examples/demo-study` is a fictional project filled in over one week. The topic and numbers are invented. The records follow the procedure as written.

- At the novelty gate, an independent agent re-judged the distance of each related paper and disagreed on one. A rule written in advance (take the closer distance) settled it, and one paper that could not be opened was left as a condition instead of being judged.
- Three tasks ran overnight and passed their checks. The agent also found that the sealed rule did not say how to count censored cases in the median, a choice that moved one result by 1.5 days. It left the choice to the user as a pending decision in the review document. The user reviewed for 18 minutes the next morning (budget: 30), accepted the two data tasks, chose an option, and sent the aggregation task back.
- Each session log ends with the same three frames: start notice, progress board, and end report.

## Start

Give your AI tool the repository URL with one of these requests:

```
Clone <url>, read AGENTS.md, tell me briefly how this could help my research, and ask about my situation.
Clone <url> and install the skills following section 4 of AGENTS.md. Show me where they will go first.
Clone <url> and create a research project at ~/Projects/<name> following AGENTS.md. Ask me for the values it needs.
```

To install only the three skills for starting a new topic:

```
ONLY=problem-grill,literature-scout,feasibility-gate code/scripts/install-skills.sh claude
```

Installed skills record the release they came from. `install-skills.sh check` reports a newer release, and `update` replaces only the skills you have not edited.

## Contents

| Path | What |
|---|---|
| `skills/` | 17 skills, one per research stage, from problem definition to rebuttal |
| `scaffold/` | `new-project.sh` and the template for a new research project |
| `templates/` | gate records, preregistration, batch plans, hand-off orders, review documents, check and review prompts |
| `docs/` | principles and procedures (01 to 09), glossary |
| `code/scripts/` | `seal.py` (seal and verify rule files), `install-skills.sh` (install and update skills), `check-banned.sh` (block banned words before a public push) |
| `examples/` | the demo project and sample gate and review records |

## Skills

| Stage | Skills |
|---|---|
| Setup | `research-scaffold`, `research-session` (common rules, session start and end, progress frames) |
| Several papers | `research-portfolio` |
| Starting a topic | `problem-grill`, `literature-scout`, `feasibility-gate` |
| Running | `preregister-seal`, `research-batch` (including work while the user is away) |
| Manuscript | `paper-framing`, `paper-quality-loop`, `paper-readability`, `paper-condense` |
| Submission | `submission-package` |
| After review | `rebuttal` |
| Shared | `fact-check`, `korean-academic-style`, `english-academic-style` |

## Limits

One researcher built these procedures for their own work. They have not been tested by teams sharing one repository or in other fields. Independent recomputation costs time, and cutting that time cuts what the procedure guarantees. The two style skills encode one person's norms and are meant to be replaced with your own.

## License

Scripts and skills: MIT (`LICENSE`). Documents, templates, and examples: CC BY 4.0 (`LICENSE-docs`).
