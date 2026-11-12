extends Control
## Nava — Phase 1 playable build.
## Ring of 12 rashi fields; flip the dealt graha, tap a field to place it
## (moves up to 2 fields away preview cost; tapping an occupied field exchanges).
## Live harmony score, band, and the three-line Reading at the end.
## UI is built in code so the scene file stays a single node.

const DISPLAY := {
	"surya": "Surya", "chandra": "Chandra", "kuja": "Kuja", "budha": "Budha",
	"guru": "Guru", "shukra": "Shukra", "shani": "Shani", "rahu": "Rahu", "ketu": "Ketu",
}

var data: GameData
var scoring: Scoring
var reading: Reading

var deal: Dictionary = {}
var flip_order: Array = []
var board: Dictionary = {}
var turn: int = 0
var move_points_spent: int = 0

var field_buttons: Dictionary = {} # field -> Button
var prompt_label: Label
var score_label: Label
var reading_label: Label

func _ready() -> void:
	data = GameData.new()
	if not data.load_from():
		return
	scoring = Scoring.new(data)
	reading = Reading.new(data, scoring)
	_build_ui()
	new_game(Time.get_ticks_msec() % 100000)

func _build_ui() -> void:
	var title := Label.new()
	title.text = "NAVA — Cards of the Nine Grahas"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	title.position = Vector2(60, 24)
	add_child(title)

	prompt_label = Label.new()
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	prompt_label.position = Vector2(40, 70)
	prompt_label.size = Vector2(640, 60)
	add_child(prompt_label)

	# Ring: 12 fields on a circle centred for a 720x1280 portrait canvas.
	var centre := Vector2(360, 480)
	var radius := 265.0
	for i in 12:
		var field: String = data.rashis[i]
		var ang := -PI / 2 + TAU * float(i) / 12.0
		var b := Button.new()
		b.custom_minimum_size = Vector2(118, 64)
		b.size = b.custom_minimum_size
		b.position = centre + Vector2(cos(ang), sin(ang)) * radius - b.size / 2
		b.text = field.capitalize()
		b.pressed.connect(_on_field_pressed.bind(field))
		add_child(b)
		field_buttons[field] = b

	score_label = Label.new()
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.position = Vector2(40, 830)
	score_label.size = Vector2(640, 40)
	add_child(score_label)

	reading_label = Label.new()
	reading_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reading_label.position = Vector2(40, 890)
	reading_label.size = Vector2(640, 260)
	add_child(reading_label)

	var again := Button.new()
	again.text = "New Game"
	again.position = Vector2(285, 1180)
	again.custom_minimum_size = Vector2(150, 56)
	again.size = again.custom_minimum_size
	again.pressed.connect(func() -> void: new_game(randi()))
	add_child(again)

func new_game(seed_value: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var fields := data.rashis.duplicate()
	_fisher_yates(fields, rng)
	var graha_ids := data.grahas.keys()
	_fisher_yates(graha_ids, rng)
	flip_order = fields.slice(0, 5)
	deal.clear()
	for i in 5:
		deal[flip_order[i]] = graha_ids[i]
	board.clear()
	turn = 0
	move_points_spent = 0
	reading_label.text = ""
	_refresh()

func _fisher_yates(arr: Array, rng: RandomNumberGenerator) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t

func _on_field_pressed(field: String) -> void:
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
		# Exchange: the placed graha returns to your hand as this turn's graha next flip.
		var displaced: String = board[field]
		deal[dealt_field] = displaced
	board[field] = g
	turn += 1
	_refresh()

func _refresh() -> void:
	for field in field_buttons:
		var b: Button = field_buttons[field]
		if board.has(field):
			b.text = "%s\n%s" % [field.capitalize(), DISPLAY.get(board[field], board[field])]
		else:
			b.text = field.capitalize()
	if turn < 5:
		var dealt_field: String = flip_order[turn]
		prompt_label.text = "Turn %d of 5 — %s was dealt to %s. Tap a field to place it (free within 1 step, 2 steps costs 1)." % [turn + 1, DISPLAY.get(deal[dealt_field], deal[dealt_field]), dealt_field.capitalize()]
		var live := scoring.score_board(board) - move_points_spent
		score_label.text = "Harmony so far: %d" % live
	else:
		var s := scoring.score_board(board) - move_points_spent
		var band := scoring.band_for(s)
		prompt_label.text = "The chart is complete."
		score_label.text = "Final harmony: %d — %s" % [s, band.capitalize()]
		var lines := reading.generate(board, s, band)
		reading_label.text = "\n".join(lines)
