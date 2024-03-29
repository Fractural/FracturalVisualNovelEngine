extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"


const HideNode = preload("hide_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("HideStatement")
	return arr


func get_keywords() -> Array:
	return ["hide", "with"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var hide = parser.expect_token("keyword", "hide")
	if parser.is_success(hide):
		var visual = parser.expect("Expression")
		if parser.is_success(visual):
			# Parse optional transition.
			var transition = _parse_transition(parser)
			if not parser.is_success(transition):
				return transition
			
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return HideNode.new(hide.position, visual, transition)
			else:
				return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
		else:
			# Confidence of 1 because we are confident once we parsed 
			# the hide keyword, we are trying to parse a hide statement.
			return parser.error("Expected an expression for the visual after \"hide\".", 1, checkpoint)
	else:
		return parser.error(hide, 0)


func _parse_transition(parser):
	var checkpoint = parser.save_reader_state()
	var with = parser.expect_token("keyword", "with")
	if parser.is_success(with):
		var transition = parser.expect("Expression")
		if parser.is_success(transition):
			return transition
		else:
			return parser.error("Expected an expression for the transition after \"with\".", 1, checkpoint)
