extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a PassStatement


const PassStatement = preload("pass_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("PassStatement")
	return arr


func get_keywords() -> Array:
	return ["pass"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var pass_keyword = parser.expect_token("keyword", "pass")
	if not parser.is_success(pass_keyword):
		return parser.error(pass_keyword, 0)
	if not parser.is_success(parser.expect_token("punctuation", "newline")):
		return parser.error("Expected a new line to conclude a statement.", checkpoint)
	return PassStatement.new(pass_keyword.position)
