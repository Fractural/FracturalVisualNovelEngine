extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"

const PauseNode = preload("pause_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("pause")
	return arr


func get_keywords() -> Array:
	return ["pause"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var pause = parser.expect_token("keyword", "pause")
	if parser.is_success(pause):
		var duration = parser.expect("expression")
		if parser.is_success(duration):
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return PauseNode.new(pause.position, duration)
			else:
				return parser.error("Expected a new line to conclude a statement")
		else:
			return parser.error("Expected an expression after pause to indicate pause duration.", 1, checkpoint)
	else:
		return parser.error(pause, 0)
