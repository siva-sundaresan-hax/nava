extends Control
## Nava — Phase 1 main scene controller (skeleton).
## Build order: deal -> flip -> place/move/exchange -> score -> reading.
## State machine only for now; card visuals bind to these signals next.

signal dealt(deal: Dictionary)
signal flipped(field: String, graha_id: String)
signal placed(board: Dictionary)
signal game_finished(score: int, band: String)

var data: GameData
var scoring: Scoring
var deal: Dictionary = {}    # field -> graha (face-down)
var flip_order: Array = []   # fields in flip order
var board: Dictionary = {}   # field -> graha (placed)
var turn: int = 0            # 0..4 (five turns, rules v0.1.1)
var move_points_spent: int = 0

func _ready() -> void:
	data = GameData.new()
	if not data.load_from():
		return
	scoring = Scoring.new(data)
	# TODO(phase1): build the 12-field ring + card nodes, bind buttons.
	new_game(42) # fixed seed until the seeded-deal module lands

func new_game(seed_value: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var fields := data.rashis.duplicate()
	fields.shuffle() # NOTE: shuffle uses global RNG; seeded deal module replaces this
	var chosen_fields := fields.slice(0, 5)
	var graha_ids := data.grahas.keys()
	graha_ids.shuffle()
	deal.clear()
	flip_order = chosen_fields
	for i in 5:
		deal[chosen_fields[i]] = graha_ids[i]
	board.clear()
	turn = 0
	move_points_spent = 0
	emit_signal("dealt", deal.duplicate())

func current_graha() -> String:
	if turn >= flip_order.size():
		return ""
	return deal[flip_order[turn]]

func place_on(target_field: String) -> void:
	var dealt_field: String = flip_order[turn]
	var g := current_graha()
	if target_field != dealt_field:
		if not scoring.move_legal(dealt_field, target_field):
			return
		move_points_spent += scoring.move_cost(dealt_field, target_field)
	board[target_field] = g
	emit_signal("placed", board.duplicate())
	turn += 1
	if turn >= 5:
		var s := scoring.score_board(board) - move_points_spent
		emit_signal("game_finished", s, scoring.band_for(s))
