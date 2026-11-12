# NAVA — Cards of the Nine Grahas

**Fate deals; you play the chart.**

Nava is an open-source strategy card game built on **Jyotisham** (Vedic astrology). Five graha cards are dealt face-down onto a ring of twelve rashi fields. Flip them one at a time and decide — place, move, or exchange — to build the most harmonious chart you can. Your final spread generates a short reading, and your harmony score is the game.

> *The classical system is the engine: the dignity table (exaltation, own sign, debilitation) and the graha friendship table (mitra / sama / shatru) are not theme — they are the combo mechanics.*

## Play it now (browser prototype)

- **English:** https://muse.ai/s/nava-card-game-prototype-xrf6xzix0ixwxaxixt/G46Lflg-TIWDSjwXAibdF_vK4fa0XuC_XOyo6D2EJus
- **Tamil (முழு தமிழ் பதிப்பு):** https://muse.ai/s/nvaa-nava-in-tamil-xjxx6xzj87xlrxcv/1aHup4XX5AZ_ZyArh_egJCr92xyc7pZDgU-9VkeEGYc

iOS & Android (Godot 4) are in development — see `docs/plan.md`.

## The game in brief

- **Deal:** 9 grahas exist; 5 are dealt face-down onto random rashi fields. You also hold nakshatra special cards (one-shot effects).
- **Turn (×5):** flip a graha, then **Place** it, **Move** it up to 2 fields (first step free, second costs 1), or **Exchange** it with a placed graha.
- **Scoring — harmony points:**
  - *Dignity:* exalted +10 · own sign +6 · friend's sign +4 · neutral +2 · enemy's sign 0 · debilitated −6
  - *Links (adjacent fields):* friends +4 · enemies −4 · Guru blesses his neighborhood +2
  - *Patterns:* element triad +9 · kendra cross +6 · full house +5
  - *The shadow grahas:* Rahu doubles his field's dignity, good or bad. Ketu's field scores 0 — but he severs your worst enemy link.
  - *Bands:* 50+ Yoga · 38–49 Harmonious · 25–37 A working chart · 12–24 Difficult · under 12, the stars were not consulted properly.
- **The Reading:** three lines read off your finished chart — strongest graha, weakest link, and the band spoken as the answer's tone. Tone, never prediction.

Full rules: `docs/rules.md` (v0.1.1, tuned by simulation — see below).

## Repository layout

| Path | What |
|---|---|
| `project.godot` | Godot 4 project scaffold (portrait, mobile renderer) — Phase 1 builds here |
| `data/game_data.json` | **The content-as-data layer** — grahas, rashis, specials, every scoring number. Balance lives here, never in code |
| `sim/simulate.py` | The rules simulator: plays thousands of games per strategy to validate scoring bands |
| `sim/results-v0.1.md` | What the simulation found, and the tuning it produced |
| `docs/rules.md` | Complete rules (paper-prototype edition) |
| `docs/plan.md` | Product plan: deck design, roadmap, monetization, the weekly prize contest |

## Test the math

```bash
python3 sim/simulate.py   # 20,000 games per strategy; prints score distributions
```

The simulator is the reference implementation of the scoring rules — any engine port (GDScript first) must reproduce its numbers on identical deals.

## Contributing

Nava is built in the open and improves the same way. See `CONTRIBUTING.md` — the short version: the paper playtest questions in `docs/rules.md` §8 are the project's compass; balance changes must come with simulator output; new card art must follow the style guide (arriving with Phase 2).

Playtest reports are contributions. Lines from real readings at real family tables have already shaped this game.

## License & brand

Code and game-design documents in this repository are licensed under the **Apache License 2.0** (see `LICENSE`), including its patent grant.

The **NAVA name, logo, and future card artwork are not** covered by that license — they remain the property of the Nava project / MambalamToTexas. Forks are welcome to build on the code and rules; please ship them under your own name and art. (This is the standard open-source-game arrangement: the engine is commons, the identity is not.)

## A note on framing

Nava is a game *set in the world of* Jyotisham, made with respect for the tradition it borrows from. It makes no predictions and sells no readings. The chart shows weather; you sail the boat.
