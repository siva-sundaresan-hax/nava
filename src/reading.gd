extends RefCounted
class_name Reading
## The Reading (rules v0.1.1 §7): three spoken sentences about the chart —
## strongest graha, weakest link, band as verdict. Tone, never prediction.

var data: GameData
var scoring: Scoring

const DISPLAY := {
	"surya": "Surya", "chandra": "Chandra", "kuja": "Kuja", "budha": "Budha",
	"guru": "Guru", "shukra": "Shukra", "shani": "Shani", "rahu": "Rahu", "ketu": "Ketu",
}

func _init(d: GameData, s: Scoring) -> void:
	data = d
	scoring = s

func generate(board: Dictionary, score: int, band: String) -> Array:
	if board.is_empty():
		return []
	var best_g := ""
	var best_v := -999
	var worst_g := ""
	var worst_v := 999
	for f in board:
		var v := scoring.dignity(board[f], f)
		if v > best_v:
			best_v = v
			best_g = board[f]
		if v < worst_v:
			worst_v = v
			worst_g = board[f]
	var field_of_best := ""
	for f in board:
		if board[f] == best_g:
			field_of_best = f
	var line1 := "%s carries this chart — placed in %s, it is the strength everything else leans on." % [DISPLAY.get(best_g, best_g), field_of_best.capitalize()]
	var line2 := "The tender point is %s. The chart does not hide it; it asks that it be tended, not feared." % DISPLAY.get(worst_g, worst_g)
	var verdicts := {
		"yoga": "Taken together, this is a Yoga — a chart in rare agreement with itself.",
		"harmonious": "Taken together, this is a Harmonious chart — the grahas are mostly in conversation, not conflict.",
		"working": "Taken together, this is a Working chart — not gifted, not broken; it rewards steady hands.",
		"difficult": "Taken together, this is a Difficult chart — friction is the material it gives you to work with.",
		"scattered": "Taken together, this chart is Scattered — and even a scattered chart is a true one. Begin where you stand.",
	}
	return [line1, line2, verdicts.get(band, verdicts["working"])]
