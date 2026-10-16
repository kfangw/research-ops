# research-ops

[![check](https://github.com/kfangw/research-ops/actions/workflows/check.yml/badge.svg)](https://github.com/kfangw/research-ops/actions/workflows/check.yml)
[![release](https://img.shields.io/github/v/release/kfangw/research-ops)](https://github.com/kfangw/research-ops/releases)
[![code: MIT](https://img.shields.io/badge/code-MIT-blue)](LICENSE)
[![docs: CC BY 4.0](https://img.shields.io/badge/docs-CC%20BY%204.0-lightgrey)](LICENSE-docs)

**Skills and procedures that let you hand research work to AI agents and still trust the results.** For Claude Code and Codex.

The documents and skills are in Korean. An AI tool given the repository URL reads `AGENTS.md` and explains the rest in your language.

## What goes wrong when agents do research

| What an agent tends to do | What this repository does |
|---|---|
| Changes the decision rule after seeing the results | Rules are written before the results and sealed with a hash, so any edit shows |
| Checks its own numbers and reports them correct | A fresh agent with no access to the earlier conversation recomputes them from the raw data |
| Writes "no prior work" when it simply did not find any | The search keeps its queries and the papers it could not open, and records "not found" apart from "does not exist" |
| Runs overnight and leaves no clear account of what it did | Before leaving, you approve what to hand off and where to stop. On return, you read a review document whose results are already checked |
| Goes silent for minutes, and you cannot tell whether it is stuck | Every task reports in the same progress board, with its status and the time of its last response |

## How it works

People decide and review. Agents search, implement, and check each other.

```
  People (daytime)                               Agents (night, meetings, weekends)

  lock the problem statement  --+
  seal the decision rules       +-- hand-off order -->  search, implement, compute
  pick tasks and stop lines   --+                              |
                                                               v
                                                     another agent recomputes
                                                               |
  merge only what you accept  <-- review document ---  open choices go back
  answer the open questions                            to people, not guessed
```

## What the demo shows

[`examples/demo-study`](examples/demo-study) is a fictional project filled in over one week. The topic and numbers are invented; the records follow the procedure as written.

- Each related paper is judged by how much it overlaps the research question. The checking agent judged one paper as closer than the first judgment did, and a rule written in advance (when judgments differ, take the closer one) settled it. A paper that could not be opened was left as an open condition rather than judged.
- Three tasks ran overnight and passed their checks. Along the way the agent found that the sealed rule did not cover one case, a choice that moved a result by 1.5 days. It left the choice to the user, who answered it during an 18-minute review the next morning and had one aggregation redone to match.

## Start

Paste this into Claude Code or Codex, replacing `<url>` with this repository's address:

```
Clone <url>, read AGENTS.md, tell me briefly how this could help my research, and ask about my situation.
```

Three skills are enough at first: `problem-grill` (state the problem in one sentence), `literature-scout` (find the closest prior work), and `feasibility-gate` (decide with criteria set in advance). To install only these:

```
ONLY=problem-grill,literature-scout,feasibility-gate code/scripts/install-skills.sh claude
```

Once installed, the skills check for a newer release once a week when a session starts. Updates never overwrite skills you have edited.

Skill directory sites may offer these skills one at a time. We advise against installing them that way: a single skill arrives without `research-session`, which holds the rules every skill relies on, and it never receives updates. Clone this repository and install with `install-skills.sh` instead.

## Skills

| Stage | Skills |
|---|---|
| Starting a topic | `problem-grill`, `literature-scout`, `feasibility-gate` |
| Running | `preregister-seal`, `research-batch` (including work while you are away) |
| Checking | `fact-check` |
| Manuscript | `paper-framing`, `paper-quality-loop`, `paper-readability`, `paper-condense` |
| Submission | `submission-package`, `rebuttal` |
| Operations | `research-scaffold`, `research-session`, `research-portfolio` |
| Style | `korean-academic-style`, `english-academic-style` |

## Limits

One researcher built these procedures for their own work, and they have not yet been tested by teams or in other fields. Recomputation costs time, and cutting that time cuts what the procedure guarantees. The two style skills encode one person's norms and are meant to be replaced.

## License

Scripts and skills: MIT ([`LICENSE`](LICENSE)). Documents, templates, and examples: CC BY 4.0 ([`LICENSE-docs`](LICENSE-docs)).
