extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"


const MoveStatement = preload("move_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("MoveStatement")
	return arr


func get_keywords() -> Array:
	return ["move", "to", "with", "for"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var move = parser.expect_token("keyword", "move")
	if parser.is_success(move):
		var visual = parser.expect("Expression")
		if parser.is_success(visual):
			if parser.is_success(parser.expect_token("keyword", "to")):
				var target_position = parser.expect("Expression")
				if parser.is_success(target_position):
					if parser.is_success(parser.expect_token("keyword", "with")):
						# Use custom travel curve (to add easing, etc).
						var travel_curve = parser.expect("Expression")
						if parser.is_success(travel_curve):
							if parser.is_success(parser.expect_token("keyword", "for")):
								var duration = parser.expect("Expression")
								if parser.is_success(duration):
									# Parse with everything (visual, travel curve, duration, etc)
									if parser.is_success(parser.expect_token("punctuation", "newline")):
										return MoveStatement.new(move.position, visual, target_position, travel_curve, duration)
									else:
										return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
								else:
									return parser.error("Expected an expression for the travel time after \"for\".", 1, checkpoint)
							else:
								# No custom time for travel curve therefore we use the default time instead
								if parser.is_success(parser.expect_token("punctuation", "newline")):
									return MoveStatement.new(move.position, visual, target_position, travel_curve)
								else:
									return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
						else:
							return parser.error("Expected an expression for the travel curve after \"with\".", 1, checkpoint)
					else:
						# No custom travel curve therefore we move immediately to target_position
						if parser.is_success(parser.expect_token("punctuation", "newline")):
							return MoveStatement.new(move.position, visual, target_position)
						else:
							return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
				else:
					return parser.error("Expected an expression for the target position after \"to\".", 1, checkpoint)
			else:
				return parser.error("Expected the keyword \"to\" in a move statement.", 1, checkpoint)
		else:
			return parser.error("Expected an expression for the visual after \"move\".", 1, checkpoint)
	else:
		return parser.error(move, 0)
