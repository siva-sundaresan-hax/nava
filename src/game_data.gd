extends RefCounted
class_name GameData
## Loads data/game_data.json (the content-as-data layer) and exposes lookups.
## Rules/scoring numbers live ONLY in the JSON — never hard-code them here.

var raw: Dictionary = {}
var rashis: Array = []          # ordered rashi ids (the ring)
var lord_of: Dictionary = {}    # rashi id -> graha id
var element_of: Dictionary = {} # rashi id -> element
var grahas: Dictionary = {}     # graha id -> graha record
var scoring: Dictionary = {}    # scoring table from the JSON

func load_from(path: String = "res://data/game_data.json") -> bool:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("GameData: cannot open %s" % path)
		return false
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("GameData: %s is not a JSON object" % path)
		return false
	raw = parsed
	for r in raw.get("rashis", []):
		rashis.append(r["id"])
		lord_of[r["id"]] = r["lord"]
		element_of[r["id"]] = r["element"]
	for g in raw.get("grahas", []):
		grahas[g["id"]] = g
	scoring = raw.get("scoring", {})
	return true

func ring_distance(a: String, b: String) -> int:
	var i := rashis.find(a)
	var j := rashis.find(b)
	var d: int = abs(i - j)
	return mini(d, 12 - d)

func neighbour(field: String) -> String:
	return rashis[(rashis.find(field) + 1) % 12]
