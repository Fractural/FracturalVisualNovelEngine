extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a ChoiceStatement.


const ChoiceStatement = preload("choice_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("ChoiceStatement")
	return arr


func get_keywords() -> Array:
	return ["choice"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var choice_keyword = parser.expect_token("keyword", "choice")
	if not parser.is_success(choice_keyword):
		return parser.error(choice_keyword, 0)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to follow the \"choice\" in a choice statement.", 1, checkpoint)
	
	if not parser.is_success(parser.expect_token("punctuation", "newline")):
		return parser.error("Expected a new line after \":\" in a choice statement.", 1, checkpoint)
	
	var choice_option_nodes: Array = []
	var choice_option_node = parser.expect("ChoiceOptionNode")
	
	while parser.is_success(choice_option_node):
		choice_option_nodes.append(choice_option_node)
		choice_option_node = parser.expect("ChoiceOptionNode")
	
	if choice_option_nodes.size() == 0:
		return parser.error("Expected at least one choice option in a choice statement.", 1, checkpoint)
	
	return ChoiceStatement.new(choice_keyword.position, choice_option_nodes)
