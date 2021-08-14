extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a FullTransitionStatement.


const FullTransitionStatement = preload("full_transition_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("FullTransitionStatement")
	return arr


func get_keywords() -> Array:
	return ["transition"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var transition_keyword = parser.expect_token("keyword", "transition")
	if not parser.is_success(transition_keyword):
		return parser.error(transition_keyword, 0)
	
	var transition = parser.expect("Expression")
	if not parser.is_success(transition):
		return parser.error("Expected an expression after \"transition\" to indicate the transition being used in the full transition statement.", 1)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to follow the \"transition\" in a full transition statement.", 1, checkpoint)
	
	var block = parser.expect("BlockNode")
	if not parser.is_success(block):
		return parser.error("Expected a block after the full transition statement.", 1, checkpoint)
	
	# TODO: Add parsing for is_skippable
	return FullTransitionStatement.new(transition_keyword.position, transition, block, false)
