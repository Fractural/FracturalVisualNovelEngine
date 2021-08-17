extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a RemoveStatement.


const RemoveStatement = preload("remove_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("RemoveStatement")
	return arr


func get_keywords() -> Array:
	return ["remove"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var remove_keyword = parser.expect_token("keyword", "remove")
	if not parser.is_success(remove_keyword):
		return parser.error(remove_keyword, 0)
	
	var actor = parser.expect("Expression")
	if not parser.is_success(actor):
		return parser.error("Expected an expression after \"remove\" to indicate the actor being removed by the remove statement.", 1, checkpoint)
	
	if not parser.is_success(parser.expect_token("punctuation", "newline")):
		return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
	
	return RemoveStatement.new(remove_keyword.position, actor)
