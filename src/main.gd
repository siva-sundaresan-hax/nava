extends Control
## Nava — Phase 1 playable build.
## Modes: Free Play (random), Daily Deal and Contest Deal (seeded, identical
## for every player — src/seeded_deal.gd). Ring of 12 rashi fields tinted by
## element; flip -> place/move/exchange; two nakshatra specials in hand;
## live harmony score; three-line Reading at the end.

const DISPLAY := {
	"surya": "Surya", "chandra": "Chandra", "kuja": "Kuja", "budha": "Budha",
	"guru": "Guru", "shukra": "Shukra", "shani": "Shani", "rahu": "Rahu", "ketu": "Ketu",
}
const ELEMENT_TINT := {
	"agni": Color(1.0, 0.82, 0.72), "prithvi": Color(0.85, 0.95, 0.78),
	"vayu": Color(0.85, 0.90, 1.0), "jala": Color(0.72, 0.90, 1.0),
}

var data: GameData
var scoring: Scoring
var reading: Reading

var mode: String = "free"
var deal_code: String = ""
var deal: Dictionary = {}
var flip_order: Array = []
var board: Dictionary = {}
var turn: int = 0
var move_points_spent: int = 0
var specials_in_hand: Array = []
var specials_used: Dictionary = {} # id -> adjustment applied
var hasta_first_pick: String = ""

var field_buttons: Dictionary = {}
var special_buttons: Dictionary = {}
var prompt_label: Label
var score_label: Label
var reading_label: Label
var mode_label: Label

func _ready() -> void:
	data = GameData.new()
	if not data.load_from():
		return
	scoring = Scoring.new(data)
	reading = Reading.new(data, scoring)
	_build_ui()
	new_free_game()

func _build_ui() -> void:
	var title := Label.new()
	title.text = "NAVA — Cards of the Nine Grahas"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(60, 20)
	add_child(title)

	mode_label = Label.new()
	mode_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mode_label.position = Vector2(40, 48)
	mode_label.size = Vector2(640, 26)
	add_child(mode_label)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_label.position = Vector2(40, 78)
	prompt_label.size = Vector2(640, 66)
	add_child(prompt_label)

	var centre := Vector2(360, 470)
	var radius := 258.0
	for i in 12:
		var field: String = data.rashis[i]
		var ang := -PI / 2 + TAU * float(i) / 12.0
		var b := Button.new()
		b.custom_minimum_size = Vector2(118, 64)
		b.size = b.custom_minimum_size
		b.position = centre + Vector2(cos(ang), sin(ang)) * radius - b.size / 2
		b.self_modulate = ELEMENT_TINT.get(data.element_of[field], Color.WHITE)
		b.pressed.connect(_on_field_pressed.bind(field))
		add_child(b)
		field_buttons[field] = b

	score_label = Label.new()
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.position = Vector2(40, 800)
	score_label.size = Vector2(640, 40)
	add_child(score_label)

	reading_label = Label.new()
	reading_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reading_label.position = Vector2(40, 850)
	reading_label.size = Vector2(640, 220)
	add_child(reading_label)

	# Specials row
	for i in 2:
		var sb := Button.new()
		sb.position = Vector2(120 + i * 250, 1090)
		sb.custom_minimum_size = Vector2(230, 52)
		sb.size = sb.custom_minimum_size
		sb.pressed.connect(_on_special_pressed.bind(i))
		add_child(sb)
		special_buttons[i] = sb

	# Mode row
	var modes := [["Free Play", "free"], ["Daily Deal", "daily"], ["Contest Deal", "contest"]]
	for i in 3:
		var mb := Button.new()
		mb.text = modes[i][0]
		mb.position = Vector2(45 + i * 215, 1180)
		mb.custom_minimum_size = Vector2(200, 56)
		mb.size = mb.custom_minimum_size
		var m: String = modes[i][1]
		mb.pressed.connect(func() -> void: _start_mode(m))
		add_child(mb)

func _start_mode(m: String) -> void:
	mode = m
	match m:
		"free":
			new_free_game()
		"daily":
			_new_seeded_game(SeededDeal.daily_seed())
		"contest":
			_new_seeded_game(SeededDeal.contest_seed())

func new_free_game() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var fields := data.rashis.duplicate()
	_fisher_yates(fields, rng)
	var graha_ids := data.grahas.keys()
	_fisher_yates(graha_ids, rng)
	var special_ids := Specials.implemented()
	_fisher_yates(special_ids, rng)
	deal_code = "FREE"
	_setup(fields.slice(0, 5), graha_ids.slice(0, 5), special_ids.slice(0, 2))

func _new_seeded_game(seed_text: String) -> void:
	var sd := SeededDeal.new(seed_text)
	var d := sd.deal_for(data, Specials.implemented())
	deal_code = seed_text.replace("NAVA-", "").to_upper()
	_setup(d["fields"], d["grahas"], d["specials"])

func _setup(fields: Array, grahas: Array, specials: Array) -> void:
	flip_order = fields
	deal.clear()
	for i in 5:
		deal[flip_order[i]] = grahas[i]
	board.clear()
	turn = 0
	move_points_spent = 0
	specials_in_hand = specials
	specials_used.clear()
	hasta_first_pick = ""
	reading_label.text = ""
	mode_label.text = "Mode: %s   Deal: %s" % [mode.capitalize(), deal_code]
	_refresh()

func _fisher_yates(arr: Array, rng: RandomNumberGenerator) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t

func final_score() -> int:
	var adj := 0
	for id in specials_used:
		adj += int(specials_used[id])
	return scoring.score_board(board) + adj - move_points_spent

func _on_field_pressed(field: String) -> void:
	if hasta_first_pick != "":
		_finish_hasta(field)
		return
	if turn >= 5:
		return
	var dealt_field: String = flip_order[turn]
	var g := String(deal[dealt_field])
	if field != dealt_field:
		if not scoring.move_legal(dealt_field, field):
			prompt_label.text = "Too far — a graha moves at most 2 fields from where it was dealt."
			return
		move_points_spent += scoring.move_cost(dealt_field, field)
	if board.has(field):
		var displaced: String = board[field]
		deal[dealt_field] = displaced
	board[field] = g
	turn += 1
	_refresh()

func _on_special_pressed(idx: int) -> void:
	if idx >= specials_in_hand.size():
		return
	var id: String = specials_in_hand[idx]
	if specials_used.has(id) or turn >= 5:
		return
	if id == "hasta":
		if board.size() < 2:
			prompt_label.text = "Hasta needs two placed grahas to swap."
			return
		hasta_first_pick = "__armed__"
		prompt_label.text = "Hasta: tap the first placed graha to swap."
		return
	var adj := Specials.adjustment(id, board, scoring, move_points_spent)
	if adj == -99999:
		prompt_label.text = "%s has no work to do on this chart yet." % Specials.NAMES[id]
		return
	specials_used[id] = adj
	_refresh()

func _finish_hasta(field: String) -> void:
	if not board.has(field):
		prompt_label.text = "Hasta swaps placed grahas — tap an occupied field."
		return
	if hasta_first_pick == "__armed__":
		hasta_first_pick = field
		prompt_label.text = "Hasta: now tap the second placed graha."
		return
	var a := hasta_first_pick
	var g1: String = board[a]
	board[a] = board[field]
	board[field] = g1
	specials_used["hasta"] = 0
	hasta_first_pick = ""
	_refresh()

func _refresh() -> void:
	for field in field_buttons:
		var b: Button = field_buttons[field]
		if board.has(field):
			b.text = "%s\n%s" % [field.capitalize(), DISPLAY.get(board[field], board[field])]
		else:
			b.text = field.capitalize()
	for i in special_buttons:
		var sb: Button = special_buttons[i]
		if i < specials_in_hand.size():
			var id: String = specials_in_hand[i]
			sb.text = ("✓ " if specials_used.has(id) else "✦ ") + Specials.NAMES[id]
			sb.disabled = specials_used.has(id)
		else:
			sb.text = ""
			sb.disabled = true
	if turn < 5:
		var dealt_field: String = flip_order[turn]
		prompt_label.text = "Turn %d of 5 — %s was dealt to %s. Tap a field to place it (free within 1 step; 2 steps costs 1)." % [turn + 1, DISPLAY.get(deal[dealt_field], deal[dealt_field]), dealt_field.capitalize()]
		score_label.text = "Harmony so far: %d" % final_score()
	else:
		var s := final_score()
		var band := scoring.band_for(s)
		prompt_label.text = "The chart is complete."
		score_label.text = "Final harmony: %d — %s" % [s, band.capitalize()]
		reading_label.text = "\n".join(reading.generate(board, s, band))
