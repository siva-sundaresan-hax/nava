# Contributing to Nava

Welcome. Nava is a small game with a real design compass — please read this before opening a pull request; it's short.

## The compass

The five playtest questions in `docs/rules.md` §8 decide what gets built:

1. Is the flip-and-place decision interesting, or is the best move always obvious?
2. Does the score *feel* like the chart?
3. Which nakshatra specials get used, and which sit dead in hand?
4. Does the Reading make people react?
5. Does a round stay under ~20 minutes?

Contributions that answer one of these — including written playtest reports from real games — are the most valuable kind there is.

## Ground rules

- **Balance changes need evidence.** Any change to scoring numbers, card effects, or the data tables must include before/after output from `sim/simulate.py` (same seed) in the PR description. Numbers move by argument, not taste.
- **Content is data.** Cards, spreads, and reading fragments go in `data/game_data.json`, not in code. If your feature needs a number hard-coded, that's a design smell — open an issue first.
- **The scoring spec is the simulator.** Engine ports must reproduce `simulate.py`'s scores on identical deals. Its tests are the contract.
- **Framing is a feature.** Nava is entertainment set in the world of Jyotisham. No prediction claims, no paid-reading mechanics, no dark patterns — in code, copy, or marketing. PRs that blur this will be declined kindly and firmly.
- **Respect the tradition.** The vocabulary (graha, rashi, nakshatra, dignity, friendship) is used as the tradition defines it wherever the game can manage. If a mechanic must simplify a classical rule, the simplification is documented in `docs/rules.md` (as the Rahu/Ketu rulings already are).

## Workflow

1. Open an issue describing the change and which compass question it serves.
2. Fork, branch (`feat/…`, `balance/…`, `fix/…`), build small.
3. PR with: what changed, why, simulator output if balance-adjacent, and a screenshot or transcript if it's player-facing.
4. Be patient and be kind — this project is maintained part-time, around a day job and (from January 2027) a newborn.

## Code of conduct

Be the kind of person a family table would invite back: generous with credit, direct with criticism of ideas, gentle with people. Harassment of any kind ends participation. (This is the short form; the maintainer may expand it as the community grows.)
