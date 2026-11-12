# Simulation results — rules v0.1 → v0.1.1 (2026-11-12)

`sim/simulate.py`, 20,000 games per strategy, seed 42. Nakshatra specials not simulated (they add a few points of upward variance).

## What the numbers said

| Strategy | Mean | Median | Old band Yoga (40+) |
|---|---|---|---|
| Fate (place as dealt — pure luck) | 18.4 | 18 | 3.6% |
| Simple (1-step moves only) | 33.4 | 33 | 27.1% |
| Greedy optimizer (uncapped moves) | 49.9 | 50 | **83.5%** |

**Diagnosis:** the dignity/luck core is healthy — luck alone averages a difficult chart, modest skill a working one. The flaw was movement: with uncapped range and a 1-point-per-step cost, a strong player simply walks every graha home. Fate stopped mattering, and the top band became the default outcome.

## The fix (v0.1.1)

1. **Move range capped at 2 fields** (first free, second costs 1). Re-tested variants: cap 2 → optimizer mean 39.8, Yoga(40+) still 48% for a *perfect* player.
2. **Bands raised** to match real play: **Yoga 50+ · Harmonious 38–49 · Working 25–37 · Difficult 12–24 · under 12 bottom.** Under the cap, a perfect optimizer reaches Yoga roughly one game in five; humans will land there rarely, which is what a top band is for.

Both changes are in `rules-v0.1.md` and `data/game_data.json` (v0.1.1).

## What simulation can't tell us (the family table's job)

- Whether the flip decision *feels* interesting rather than obvious.
- Whether a high score *feels* like a harmonious chart.
- Whether the Reading lands. The sim has no heart; Appa and Amma do.
