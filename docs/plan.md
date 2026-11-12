# Plan — NAVA, the Tarot Game for iOS & Android

**Name DECIDED 2026-11-12: NAVA** — from *Navagraha*, the nine; it also means "new." Store title: **"Nava — Cards of the Nine Grahas."** (Chosen over Jathakam and Hora; bare "Graha" was ruled out — the stores are already crowded with Graha calculators and mini-games.)

Written 2026-11-12 (~12:55am) at Siva's request. This plan makes the format decision from his ask: **digital-first, a real game, on iOS and Android.** Recommendations below are defaults he can override; each is marked where a fork from the chain's seed questions is being settled or left open.

## The game in one line

**A mobile card game where you play a Jyotisham chart well.** Each run is a reading you *play*: draw a spread, place graha cards against rashi fields, chain nakshatra effects, and score by building harmony out of a difficult chart. The draw is fate; the score is skill.

## Settled by this plan (from the chain's open forks)

- **Format:** digital mobile game, iOS + Android, single codebase. (Physical deck becomes a later tie-in, not v1.)
- **Primary:** game-first — win/lose, strategy, progression. A daily-draw reading mode rides along as the retention hook, not the product.
- **Fusion:** the Jyotisham-fused deck is the product (below). Classic tarot structure is the fallback skin, not the lead.
- **Audience, v1:** diaspora astrology-curious players + the global "cozy strategy card game" crowd. India-first expansion after soft launch data.
- **Brand placement:** still Siva's open call — plan assumes standalone store presence with MambalamToTexas as the marketing channel, which works under either answer.

## The deck (v1: 63 cards — deliberately not 78)

- **9 Graha Majors** — Surya, Chandra, Kuja, Budha, Guru, Shukra, Shani, Rahu, Ketu. The power cards; each with a nature (benefic/malefic/neutral), an exaltation and debilitation rashi, and friends/enemies among the other grahas (the classical mitra/sama/shatru table is the combo system — it already exists, we just deal it).
- **36 Rashi Minors** — 12 rashis × 3 ranks (Pada / Bhava / Kshetra), grouped into the four element families: Agni (Mesha, Simha, Dhanusu), Prithvi (Rishaba, Kanya, Makara), Vayu (Mithuna, Tula, Kumbha), Jala (Karka, Vrischika, Meena). These are the field cards spreads are played onto.
- **27 Nakshatra Specials** — wait, scoped honestly: **18 in v1** (the remaining 9 ship in the first content update). One-shot effect cards: wildcards, rescues, doubles, curses — each named for its star (Ashwini = the healers' dash, Rohini = growth, Mula = uproot and rebuild, etc.). Nakshatra lordships create natural synergies with the graha majors.

63 unique artworks + card back + spread board. That number is the art budget of the whole project — see the art pipeline below.

## Core loop (the game in 5 minutes)

1. **The Question** — each run opens with a seeker's question (career, love, a journey, a risk). Story-flavored; gives the run a frame.
2. **The Deal** — a spread is dealt face-down onto rashi fields (3-card runs at first; 5 and 9 unlock).
3. **The Play** — flip and place graha cards; score harmony: a graha in its exaltation rashi scores big, friends adjacent chain, enemies adjacent cost you unless a nakshatra special mediates. Debilitated placements can be rescued — or sacrificed for position.
4. **The Reading** — the finished spread generates a short reading of the seeker's question, assembled from the actual cards played. This is the shareable artifact (the screenshot players send friends).
5. **Progression** — stars earned unlock nakshatra chapters, harder spreads, and cosmetic deck backs. Daily Spread (one shared puzzle per day, Wordle-style) is the retention engine and the social hook.

**Modes at launch:** Solo Runs (the core), Daily Spread, and Duel vs AI (both players read the same deal — higher harmony wins). **Not at launch:** PvP multiplayer, story campaign beyond chapter intros, physical tie-in. Each is a named later phase, not a launch risk.

## Tech plan

- **Engine: Godot 4** (recommended). Free, genuinely cross-platform, excellent 2D/card tooling, exports clean iOS/Android builds. Suits a solo/small team and a card game's needs. **Fallback: Unity** if hiring contractors (larger talent pool, C#), at the cost of weight and licensing noise. Web export from Godot doubles as the free demo/landing page.
- **Backend: minimal by design.** No accounts at launch. Local saves; anonymous analytics (PostHog/TelemetryDeck-class); a tiny cloud function only for the Daily Spread seed and leaderboards (can start as a static daily JSON — same puzzle for everyone needs no server at all on day one).
- **Content as data:** every card, spread, and reading fragment lives in JSON/spreadsheets, not code — so balance patches and new chapters ship without engineering, and the reading generator is a data problem, not an AI problem. (An optional AI-reading mode is a v2 question, deliberately not v1 scope.)
- **Stores:** Apple Developer $99/yr; Google Play $25 once. Budget the review cycles: Apple's fortune-telling-adjacent scrutiny is the known slow lane — the store listing frames this as a *strategy card game set in the world of Indian astrology*, entertainment framing throughout, no prediction claims anywhere in copy or screenshots.

## Art pipeline (the make-or-break workstream)

- **Style guide first, one page:** palette (deep indigo/gold/marigold), line language, one temple-architecture frame shared by all cards. Every card is generated *inside* that frame — consistency comes from the system, not from luck.
- **AI-assisted generation + human pass** (the route his Ghibli family work already proves): generate per-card, select, unify with a finishing pass (grain, palette clamp, frame), at print resolution so the same art serves a future physical deck.
- **Pacing: 63 cards ≈ 4–6 focused weeks** part-time at ~2 finished cards/day. This is the critical path; code should never wait on art beyond the prototype (prototype uses placeholder frames + final UI).

## Roadmap (part-time pace, evenings — honest calendar)

- **Phase 0 — Design & paper prototype (weeks 1–3):** rules locked by playing it on paper/with index cards against family and friends; if the harmony-scoring isn't fun on paper, it won't be fun on glass. Deliverable: 2-page rules + tuned scoring table.
- **Phase 1 — Playable prototype (weeks 4–8):** Godot build, placeholder art, Solo Runs + scoring + reading generator skeleton. TestFlight/Play internal track. Kill/pivot gate: 10 outside testers, do they play a second run unprompted?
- **Phase 2 — Art & beta (weeks 9–16):** the 63-card art pipeline runs as the critical path; Daily Spread added; sound pass (freelance); closed beta 100–300 players from the MambalamToTexas audience.
- **Phase 3 — Soft launch (weeks 17–20):** store pages, India + US/Canada release, free with the monetization below; measure D1/D7 retention before any ad spend.
- **Phase 4 — Growth (post-launch):** remaining 9 nakshatras, story chapters, Duel ranked, and the physical-deck Kickstarter question — with real player numbers in hand.

Total to soft launch: roughly **4–5 months part-time**, overlapping the baby's first months — which is why the scope is cut where it is. If time gets tighter, Phase 2's card count is the dial (45 cards still plays).

## Monetization (kept clean on purpose)

- **Free to play**, generous core.
- **Premium unlock ($4.99–$7.99 one-time):** all chapters, Duel mode, no ads. One-time, not a subscription — fits the audience and the brand's honesty line.
- **Cosmetics:** deck backs and board themes ($0.99–$2.99) — the art is the product, sell the art.
- **No** paid "readings," no prediction claims, no gacha. Apart from the ethics, app-store policy on fortune-telling monetization is a minefield the game framing avoids entirely.
- **DECIDED 2026-11-12 — the cash prize is Model 1:** a sponsor-funded, free-entry **weekly skill contest** on the (same-deal) Daily Spread — highest harmony score wins, default prize **$50/week**, run community-side (X entries via screenshot + #NavaWeekly) outside the app stores. Official rules drafted at `contest-rules-draft.md` — **attorney review required before the first prize is paid**. Entry-fee tournaments (Skillz-class platforms) are a later, volume-gated option; informal player-funded pools are a permanent no.

## Costs to soft launch (rough, excl. Siva's time)

- Store fees ~$124 · engine $0 · analytics/backend ~$0–20/mo · freelance sound ~$300–600 · test devices (already owned) · optional contractor art help $0–2,000.
- **Realistic total: under $1,000 solo; under $3,000 with help.** The scarce resource is evenings, not money.

## Risks named plainly

1. **Art consistency** — the #1 risk; mitigated by the frame system + finishing pass, and by cutting to 45 cards if needed.
2. **"Is it fun on paper?"** — Phase 0 exists to answer this cheaply before any code.
3. **Store review framing** — entertainment/strategy framing from the first screenshot; never the word "predict."
4. **Scope gravity** — 78 cards, multiplayer, and AI readings all pull; all three are deliberately post-launch.
5. **The baby** — January changes the calendar; the roadmap is part-time-shaped on purpose, and Phase 0 paper play is deliberately family-table work (Appa and Amma can playtest over coffee — which, for a game about reading charts, is also research).

## Decisions still Siva's

1. ~~**Name**~~ — **DECIDED 2026-11-12: NAVA** (see header). It goes on the card back in Phase 2 art.
2. **Brand slot** — does the game take MambalamToTexas product #1 from Ganessa, or launch standalone with the channel as its megaphone? (Plan works either way; store copy needs the answer by Phase 3.)
3. ~~**Engine confirm**~~ — **DECIDED 2026-11-12: Godot 4** (free/MIT, 2D-native, featherweight builds, git-friendly; Unity's edge was ecosystem and hiring pool, weighed and set aside for a solo build). The tech plan's Godot recommendation above is now the decision of record.
