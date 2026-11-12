#!/usr/bin/env python3
"""Simulate Nava rules v0.1 to validate the scoring bands.

Strategies:
  fate   - place every graha exactly where dealt (no moves). The luck baseline.
  simple - move only when a 1-step move clearly improves dignity.
  greedy - sequentially choose the best reachable empty field (dignity + links - move cost).

Nakshatra specials are NOT simulated (they add upward variance on top).
"""
import json, random, statistics, os

HERE = os.path.dirname(os.path.abspath(__file__))
DATA = json.load(open(os.path.join(HERE, "..", "data", "game_data.json")))

RASHIS = [r["id"] for r in DATA["rashis"]]
LORD = {r["id"]: r["lord"] for r in DATA["rashis"]}
ELEMENT = {r["id"]: r["element"] for r in DATA["rashis"]}
G = {g["id"]: g for g in DATA["grahas"]}
GRAHAS = list(G.keys())
SC = DATA["scoring"]
DIG = SC["dignity"]
KENDRA = {"mesha", "karka", "tula", "makara"}


def dignity(g, field):
    info = G[g]
    if field == info["exalted"]:
        v = DIG["exalted"]
    elif field == info["debilitated"]:
        v = DIG["debilitated"]
    elif LORD[field] == g:
        v = DIG["own"]
    elif LORD[field] in info["friends"]:
        v = DIG["friend_sign"]
    elif LORD[field] in info["enemies"]:
        v = DIG["enemy_sign"]
    else:
        v = DIG["neutral_sign"]
    if info.get("special") == "amplify":
        v *= 2
    if info.get("special") == "sever":
        v = 0
    return v


def relation(a, b):
    if b in G[a]["enemies"] or a in G[b]["enemies"]:
        return "enemy"
    if b in G[a]["friends"] or a in G[b]["friends"]:
        return "friend"
    return "neutral"


def score_board(board):
    """board: dict field -> graha. Returns total score."""
    total = sum(dignity(g, f) for f, g in board.items())
    fields = list(board.keys())
    idx = {r: i for i, r in enumerate(RASHIS)}
    enemy_links = []
    for f, g in board.items():
        nxt = RASHIS[(idx[f] + 1) % 12]
        if nxt in board:
            rel = relation(g, board[nxt])
            if rel == "friend":
                total += SC["links"]["friend_pair"]
            elif rel == "enemy":
                enemy_links.append(SC["links"]["enemy_pair"])
            if g == "guru" or board[nxt] == "guru":
                total += SC["links"]["guru_blessing_per_pair"]
    # Ketu severs: cancel the single worst enemy link
    if "ketu" in board.values() and enemy_links:
        enemy_links.remove(min(enemy_links))
    total += sum(enemy_links)
    # patterns
    by_el = {}
    for f in fields:
        by_el.setdefault(ELEMENT[f], []).append(f)
    for el, fs in by_el.items():
        triad = {r for r in RASHIS if ELEMENT[r] == el}
        if triad.issubset(set(fields)):
            total += SC["patterns"]["element_triad"]
    if sum(1 for f in fields if f in KENDRA) >= 3:
        total += SC["patterns"]["kendra_cross_3plus"]
    if all(dignity(g, f) > 0 or (G[g].get("special") == "sever")
           for f, g in board.items()):
        total += SC["patterns"]["full_house"]
    return total


def ring_distance(a, b):
    i, j = RASHIS.index(a), RASHIS.index(b)
    d = abs(i - j)
    return min(d, 12 - d)


def move_cost(dealt, target):
    d = ring_distance(dealt, target)
    return 0 if d <= 1 else (d - 1) * SC["move_cost"]["per_extra_step"]


def play(strategy, rng):
    dealt_fields = rng.sample(RASHIS, 5)
    dealt_grahas = rng.sample(GRAHAS, 5)
    deal = dict(zip(dealt_fields, dealt_grahas))  # field -> graha (face-down)
    board = {}
    spent = 0
    # flip order: the order fields were sampled
    for field in dealt_fields:
        g = deal[field]
        if strategy == "fate":
            board[field] = g
            continue
        best_field, best_val = field, dignity(g, field) + partial_links(board, field, g)
        for cand in RASHIS:
            if cand in board:
                continue
            d = ring_distance(field, cand)
            if strategy == "simple" and d > 1:
                continue
            val = dignity(g, cand) + partial_links(board, cand, g) - move_cost(field, cand)
            if val > best_val:
                best_val, best_field = val, cand
        spent += move_cost(field, best_field)
        board[best_field] = g
    return score_board(board) - spent


def partial_links(board, field, g):
    idx = {r: i for i, r in enumerate(RASHIS)}
    total = 0
    for nb in (RASHIS[(idx[field] - 1) % 12], RASHIS[(idx[field] + 1) % 12]):
        if nb in board:
            rel = relation(g, board[nb])
            if rel == "friend":
                total += SC["links"]["friend_pair"]
            elif rel == "enemy":
                total += SC["links"]["enemy_pair"]
            if g == "guru" or board[nb] == "guru":
                total += SC["links"]["guru_blessing_per_pair"]
    return total


def main(n=20000):
    rng = random.Random(42)
    for strat in ("fate", "simple", "greedy"):
        scores = [play(strat, rng) for _ in range(n)]
        bands = DATA["scoring"]["bands"]
        dist = {
            "Yoga (40+)": sum(1 for s in scores if s >= bands["yoga"]),
            "Harmonious (30-39)": sum(1 for s in scores if bands["harmonious"] <= s < bands["yoga"]),
            "Working (20-29)": sum(1 for s in scores if bands["working"] <= s < bands["harmonious"]),
            "Difficult (10-19)": sum(1 for s in scores if bands["difficult"] <= s < bands["working"]),
            "Under 10": sum(1 for s in scores if s < bands["difficult"]),
        }
        print(f"\n== {strat} ==  mean {statistics.mean(scores):.1f}  median "
              f"{statistics.median(scores):.0f}  p10 {sorted(scores)[n//10]}  p90 {sorted(scores)[9*n//10]}")
        for k, v in dist.items():
            print(f"   {k:22s} {100*v/n:5.1f}%")


if __name__ == "__main__":
    main()
