# NAVA — Rules v0.1 (paper-prototype edition)

Drafted 2026-11-12, ~1:00am, for family-table playtesting. Everything here is playable tonight with index cards and a pen. Numbers are first guesses — the playtest's job is to break them.

**The idea in one breath:** fate deals the spread; you play the chart. Place graha cards onto rashi fields to build the most harmonious chart you can — then read what you built.

---

## 1. What you need (paper version)

- **9 Graha cards** — Surya ☉, Chandra ☽, Kuja ♂, Budha ☿, Guru ♃, Shukra ♀, Shani ♄, Rahu ☊, Ketu ☋.
- **12 Rashi field cards** — Mesha, Rishaba, Mithuna, Karka, Simha, Kanya, Tula, Vrischika, Dhanusu, Makara, Kumbha, Meena. (In the full game there are 36 rashi minors; the paper game uses the 12 fields only.)
- **9 Nakshatra special cards** for the prototype (of 18 in the full game): Ashwini, Rohini, Pushya, Hasta, Swati, Anuradha, Mula, Shatabhisha, Revati.
- A scoresheet. 1–4 players; solo works. ~15 minutes a game.

## 2. The reference tables (this is the game's engine — classical Jyotisham, dealt)

**Dignity — where each graha is strong or weak:**

| Graha | Exalted (♾ best) | Own sign(s) | Debilitated (weakest) |
|---|---|---|---|
| Surya | Mesha | Simha | Tula |
| Chandra | Rishaba | Karka | Vrischika |
| Kuja | Makara | Mesha, Vrischika | Karka |
| Budha | Kanya | Mithuna, Kanya | Meena |
| Guru | Karka | Dhanusu, Meena | Makara |
| Shukra | Meena | Rishaba, Tula | Kanya |
| Shani | Tula | Makara, Kumbha | Mesha |
| Rahu | Mithuna | Kumbha (game ruling) | Dhanusu |
| Ketu | Dhanusu | Vrischika (game ruling) | Mithuna |

**Friendships (natural, naisargika) — the combo system:**

| Graha | Friends | Enemies | Neutral |
|---|---|---|---|
| Surya | Chandra, Kuja, Guru | Shukra, Shani | Budha |
| Chandra | Surya, Budha | — (none) | Kuja, Guru, Shukra, Shani |
| Kuja | Surya, Chandra, Guru | Budha | Shukra, Shani |
| Budha | Surya, Shukra | Chandra | Kuja, Guru, Shani |
| Guru | Surya, Chandra, Kuja | Budha, Shukra | Shani |
| Shukra | Budha, Shani | Surya, Chandra | Kuja, Guru |
| Shani | Budha, Shukra | Surya, Chandra, Kuja | Guru |

Rahu and Ketu stand outside the table: **Rahu amplifies** whatever field he lands on (doubles its dignity score, good or bad). **Ketu severs** (the field he lands on scores 0, but he breaks one enemy link anywhere on the board — detachment as a tool).

**Element families (the four triads):** Agni — Mesha, Simha, Dhanusu · Prithvi — Rishaba, Kanya, Makara · Vayu — Mithuna, Tula, Kumbha · Jala — Karka, Vrischika, Meena.

## 3. Setup

1. Lay the 12 rashi fields in a ring, in zodiac order. This is the chart.
2. Shuffle the 9 graha cards; deal **5 face-down** onto 5 fields drawn at random (place a coin on 5 fields first). The face-down fields are **the given** — fate's part.
3. Each player draws **1 nakshatra special** (solo: draw 2, keep both).
4. Take a **Question card** — in the paper game, just say a question aloud: a journey, a job, a risk, a wedding. The chart you build is its answer.

## 4. A turn (the whole game is 5 turns)

Flip one face-down graha. You now have **three moves, use one**:

- **Place** — put it on its field (the one it was dealt to). Simple, final.
- **Move** — shift it up to **2 fields** clockwise or counter-clockwise: the first field is free, the second costs 1 point. No further — the deal must matter. A graha may only rest on an empty field. *(Range cap added in v0.1.1 tuning: simulation showed uncapped movement lets a perfect player reach the top band 83% of the time — fate stopped mattering.)*
- **Exchange** — swap it with an already-placed graha. (The swapped graha keeps its new field; its score is recalculated at the end, not now.)

Then, optionally, **play your nakshatra special** (once per game per card — see §6).

When all 5 grahas are flipped and placed, the game ends. Score (§5), then read the chart (§7).

## 5. Scoring — harmony points

**Dignity (per placed graha):**
- Exalted: **+10** · Own sign: **+6** · Friend's sign: **+4** · Neutral sign: **+2** · Enemy's sign: **0** · Debilitated: **−6**
- (Sign lord = the graha who owns the field's rashi. "Friend's sign" = the field's lord is your friend. Rahu doubles his field's dignity, + or −. Ketu's field scores 0.)

**Links (adjacent fields in the ring, per pair):**
- Two friends side by side: **+4** · Two enemies side by side: **−4** (unless mediated — §6) · Guru adjacent to anyone: **+2** (the teacher blesses the neighborhood; Guru's own enemy rule still applies to his dignity, not his blessing).

**Patterns (once each):**
- **Element triad:** all three fields of one element occupied: **+9**
- **Kendra cross:** the four angular fields (Mesha, Karka, Tula, Makara) — if 3+ are occupied: **+6**
- **Full house:** all 5 grahas in dignity 0 or better (nobody in an enemy sign or debilitated): **+5**

**Solo bands (v0.1.1, recalibrated by simulation — see `nava-prototype/sim/results-v0.1.md`):** 50+ = *Yoga* (a chart for the ages) · 38–49 = *Harmonious* · 25–37 = *A working chart* · 12–24 = *A difficult chart, honestly read* · under 12 = *The stars were not consulted properly* (play again). Pure luck averages ~18 (a difficult chart); modest skill ~33 (a working one); mastery earns Harmonious, and Yoga stays rare.
**Duel:** both players play the same deal, same fields — higher score wins; ties broken by fewest enemy links.

## 6. Nakshatra specials (prototype 9 — one-shot, then discarded)

- **Ashwini** (the healers) — Rescue: a debilitated graha scores +2 instead of −6.
- **Rohini** (growth) — One placed graha's dignity points double.
- **Pushya** (nourishment) — Move any graha one extra field free.
- **Hasta** (the hand) — Swap two placed grahas' fields.
- **Swati** (the reed in the wind) — Re-flip: return one unflipped graha to the deck and draw its replacement from the undealt grahas.
- **Anuradha** (friendship through discipline) — Mediate: one enemy link costs 0 instead of −4.
- **Mula** (the root) — Uproot: remove one placed graha from the board entirely; it scores 0 and breaks all its links (good and bad).
- **Shatabhisha** (the veil) — Hide one enemy link: it scores as neutral.
- **Revati** (the safe journey home) — At scoring, your lowest-scoring graha counts as +2.

(The full game's remaining 9 — Bharani, Mrigashira, Magha, Chitra, Vishakha, Jyeshtha, Shravana, Dhanishta, Purva Bhadrapada — get written after the prototype proves these 9 earn their keep.)

## 7. The Reading (2 minutes, the part players will screenshot)

Read the finished chart aloud, three sentences:
1. **The strongest graha** (highest dignity): *"Guru stands exalted — counsel and patience carry this question."*
2. **The weakest graha or worst link:** *"But Kuja fights with Budha on the road — expect friction in the planning."*
3. **The verdict from the band:** Yoga / Harmonious / Working / Difficult — spoken as the answer's tone, never as a prediction: *"A working chart: the thing succeeds if it's built carefully."*

Sentence stems for all 9 grahas × strong/weak are Phase 1 content; at the family table, improvise — and write down any line that lands. Those lines are gold; they're the game's voice being born.

## 8. The playtest — what tonight/tomorrow must answer

1. Is the flip-and-place decision actually interesting, or is the best move always obvious? (If obvious: the Exchange move needs a cost.)
2. Does the score *feel* like the chart? When a chart looks harmonious, is it?
3. Which nakshatra specials get used, which sit dead in hand? (Dead cards get cut or rewritten — no sentimentality.)
4. Does the Reading make people react — laugh, nod, argue? That reaction is the product.
5. Game length: if a round runs past 20 minutes, the 5-graha deal shrinks to 4.

Write answers on the scoresheet's back. Phase 1 (the Godot prototype) builds only what survives these five questions.

*Rules v0.1 — Nava. Fate deals; you play the chart.*
