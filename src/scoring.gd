extends RefCounted
class_name Scoring
## Faithful GDScript port of sim/simulate.py's score_board (rules v0.1.1).
## The simulator is the spec: for any board, this must return the same total.
## Verified by cross-check fixtures in sim/ (see repo README, Phase 1).

var data: GameData

func _init(d: GameData) -> void:
	data = d

func dignity(graha_id: String, field: String) -> int:
	var info: Dictionary = data.grahas[graha_id]
	var dig: Dictionary = data.scoring["dignity"]
	var v: int
	if field == info.get("exalted", ""):
		v = dig["exalted"]
	elif field == info.get("debilitated", ""):
		v = dig["debilitated"]
	elif data.lord_of[field] == graha_id:
		v = dig["own"]
	elif info.get("friends", []).has(data.lord_of[field]):
		v = dig["friend_sign"]
	elif info.get("enemies", []).has(data.lord_of[field]):
		v = dig["enemy_sign"]
	else:
		v = dig["neutral_sign"]
	if info.get("special", "") == "amplify": # Rahu doubles, good or bad
		v *= 2
	if info.get("special", "") == "sever":   # Ketu's own field scores 0
		v = 0
	return v

func relation(a: String, b: String) -> String:
	if data.grahas[a].get("enemies", []).has(b) or data.grahas[b].get("enemies", []).has(a):
		return "enemy"
	if data.grahas[a].get("friends", []).has(b) or data.grahas[b].get("friends", []).has(a):
		return "friend"
	return "neutral"

## board: Dictionary field(rashi id) -> graha id. Returns total harmony score.
func score_board(board: Dictionary) -> int:
	var total := 0
	for f in board:
		total += dignity(board[f], f)
	var enemy_links: Array = []
	for f in board:
		var nxt := data.neighbour(f)
		if board.has(nxt):
			var rel := relation(board[f], board[nxt])
			if rel == "friend":
				total += data.scoring["links"]["friend_pair"]
			elif rel == "enemy":
				enemy_links.append(data.scoring["links"]["enemy_pair"])
			if board[f] == "guru" or board[nxt] == "guru":
				total += data.scoring["links"]["guru_blessing_per_pair"]
	# Ketu severs the single worst enemy link
	if board.values().has("ketu") and not enemy_links.is_empty():
		enemy_links.erase(enemy_links.min())
	for e in enemy_links:
		total += e
	# Patterns
	var kendra := {"mesha": true, "karka": true, "tula": true, "makara": true}
	var by_element: Dictionary = {}
	for f in board:
		by_element.get_or_add(data.element_of[f], []).append(f)
	for el in by_element:
		var triad_complete := true
		for r in data.rashis:
			if data.element_of[r] == el and not board.has(r):
				triad_complete = false
				break
		if triad_complete:
			total += data.scoring["patterns"]["element_triad"]
	var kendra_count := 0
	for f in board:
		if kendra.has(f):
			kendra_count += 1
	if kendra_count >= 3:
		total += data.scoring["patterns"]["kendra_cross_3plus"]
	var full := true
	for f in board:
		if dignity(board[f], f) <= 0 and data.grahas[board[f]].get("special", "") != "sever":
			full = false
			break
	if full:
		total += data.scoring["patterns"]["full_house"]
	return total

func move_cost(dealt: String, target: String) -> int:
	var d := data.ring_distance(dealt, target)
	if d <= 1:
		return 0
	return (d - 1) * int(data.scoring["move_cost"]["per_extra_step"])

func move_legal(dealt: String, target: String) -> bool:
	return data.ring_distance(dealt, target) <= 2 # rules v0.1.1: range cap 2 fields

func band_for(score: int) -> String:
	var bands: Dictionary = data.scoring.get("bands", {})
	for band in ["yoga", "harmonious", "working", "difficult"]:
		if bands.has(band) and score >= int(bands[band]):
			return band
	return "scattered"
