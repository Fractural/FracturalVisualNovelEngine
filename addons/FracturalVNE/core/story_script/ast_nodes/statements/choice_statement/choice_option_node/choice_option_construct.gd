extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a ChoiceOptionNode


const ChoiceOptionNode = preload("choice_option_node.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("ChoiceOption")
	return arr


func get_keywords() -> Array:
	return ["if"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var string_literal = parser.expect("StringLiteral")
	if not parser.is_success(string_literal):
		return parser.error(string_literal, 0)
	
	var condition = null
	if parser.is_success(parser.expect_token("keyword", "if")):
		condition = parser.expect("Expression")
		if not parser.is_success(condition):
			return parser.error("Expected a conditional expression after the \"if\" keyword.", 1, checkpoint)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to close a choice option declaration.", 1, checkpoint)
	
	var block = parser.expect("BlockNode")
	if not parser.is_success(block):
		return parser.error(block, 1, checkpoint)
	
	return ChoiceOptionNode.new(string_literal.position, string_literal, block)
