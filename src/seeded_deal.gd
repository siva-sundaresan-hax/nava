extends RefCounted
class_name SeededDeal
## Deterministic deals, identical to the browser build's scheme:
## FNV-1a hash of the seed string -> mulberry32 stream.
## Seed strings: "NAVA-daily-YYYY-MM-DD" and "NAVA-contest-YYYY-MM-DD"
## (dates in America/Chicago). Same seed -> same fields, grahas, specials,
## on every device. This is what makes Daily Deal and the Weekly Contest fair.

static func fnv1a(text: String) -> int:
	var h: int = 0x811c9dc5
	for i in text.length():
		h = (h ^ text.unicode_at(i)) & 0xffffffff
		h = (h * 0x01000193) & 0xffffffff
	return h

var _state: int = 0

func _init(seed_text: String) -> void:
	_state = fnv1a(seed_text)

func next_u32() -> int:
	_state = (_state + 0x6D2B79F5) & 0xffffffff
	var t: int = _state
	t = ((t ^ (t >> 15)) * (t | 1)) & 0xffffffff
	t = (t ^ (t + (((t ^ (t >> 7)) * (t | 61)) & 0xffffffff))) & 0xffffffff
	return (t ^ (t >> 14)) & 0xffffffff

func randi_range_inclusive(lo: int, hi: int) -> int:
	return lo + int(next_u32() % (hi - lo + 1))

func shuffled(arr: Array) -> Array:
	var a := arr.duplicate()
	for i in range(a.size() - 1, 0, -1):
		var j := randi_range_inclusive(0, i)
		var t = a[i]
		a[i] = a[j]
		a[j] = t
	return a

## Returns {fields: Array(5), grahas: Array(5), specials: Array(2)}
func deal_for(data: GameData, special_ids: Array) -> Dictionary:
	var fields := shuffled(data.rashis).slice(0, 5)
	var grahas := shuffled(data.grahas.keys()).slice(0, 5)
	var specials := shuffled(special_ids).slice(0, 2)
	return {"fields": fields, "grahas": grahas, "specials": specials}

static func today_chicago() -> Dictionary:
	# Time.get_datetime_dict_from_system is local-device time; devices on CT
	# match the reference build. (TODO: fixed UTC-6/-5 conversion for travel.)
	return Time.get_date_dict_from_system()

static func daily_seed(d: Dictionary = {}) -> String:
	if d.is_empty():
		d = today_chicago()
	return "NAVA-daily-%04d-%02d-%02d" % [d["year"], d["month"], d["day"]]

static func contest_seed(d: Dictionary = {}) -> String:
	if d.is_empty():
		d = today_chicago()
	# Monday of the current week (weekday: 0=Sunday .. 6=Saturday in Godot)
	var unix := Time.get_unix_time_from_datetime_dict({
		"year": d["year"], "month": d["month"], "day": d["day"],
		"hour": 12, "minute": 0, "second": 0})
	var weekday := int(Time.get_date_dict_from_unix_time(int(unix))["weekday"])
	var back := (weekday + 6) % 7 # days since Monday
	var monday := Time.get_date_dict_from_unix_time(int(unix) - back * 86400)
	return "NAVA-contest-%04d-%02d-%02d" % [monday["year"], monday["month"], monday["day"]]
