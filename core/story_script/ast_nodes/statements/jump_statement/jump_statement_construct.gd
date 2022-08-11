extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"


const JumpNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/jump_statement/jump_statement.gd")


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("JumpStatement")
	return arr


func get_keywords() -> Array:
	return ["jump"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var jump = parser.expect_token("keyword", "jump")
	if parser.is_success(jump):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return JumpNode.new(jump.position, identifier.symbol)
			return parser.error("Expected a new line to conclude a statement.", 1/2.0, checkpoint)
		else:
			return parser.error(identifier, 1/2.0, checkpoint)
	else:
		return parser.error(jump, 0)
