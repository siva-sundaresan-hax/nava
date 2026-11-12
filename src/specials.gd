extends RefCounted
class_name Specials
## Nakshatra specials (rules v0.1.1 §6) — the five implemented in Phase 1.
## One-tap specials choose their target by the rule's own logic; Hasta is
## two-tap (pick two placed grahas to swap fields). The rest of the nine
## (swati, mula, shatabhisha, revati) land with playtest feedback.

const NAMES := {
	"ashwini": "Ashwini", "rohini": "Rohini", "pushya": "Pushya",
	"hasta": "Hasta", "anuradha": "Anuradha",
}

static func implemented() -> Array:
	return ["ashwini", "rohini", "pushya", "hasta", "anuradha"]

## Score adjustment for a one-tap special, or -99999 if it has no legal use now.
static func adjustment(id: String, board: Dictionary, scoring: Scoring, move_points_spent: int) -> int:
	match id:
		"rohini": # double the dignity of your strongest placed graha
			var best := -999
			for f in board:
				best = maxi(best, scoring.dignity(board[f], f))
			return best if best > 0 else -99999
		"ashwini": # rescue: floor a debilitated graha at +2
			var worst := 999
			for f in board:
				var v := scoring.dignity(board[f], f)
				if v < 0:
					worst = mini(worst, v)
			return (2 - worst) if worst < 0 else -99999
		"anuradha": # mediate one enemy link (+4 cancels the -4)
			for f in board:
				var nxt: String = scoring.data.neighbour(f)
				if board.has(nxt) and scoring.relation(board[f], board[nxt]) == "enemy":
					return 4
			return -99999
		"pushya": # the free extra move: refund what movement has cost you
			return move_points_spent if move_points_spent > 0 else -99999
	return -99999
