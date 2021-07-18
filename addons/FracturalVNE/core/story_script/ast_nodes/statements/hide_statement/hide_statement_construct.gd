extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"

const HideNode = preload("hide_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("hide")
	return arr


func get_keywords() -> Array:
	return ["hide", "with"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var hide = parser.expect_token("keyword", "hide")
	if parser.is_success(hide):
		var visual = parser.expect("variable")
		if parser.is_success(visual):
			# Parse optional animation.
			var animation = _parse_animation(parser)
			if not parser.is_success(animation):
				return animation
			
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return HideNode.new(hide.position, visual, animation)
			else:
				return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
		else:
			# Confidence of 1 because we are confident once we parsed 
			# the hide keyword, we are trying to parse a hide statement.
			return parser.error("Expected a variable after hide.", 1, checkpoint)
	else:
		return parser.error(hide, 0)


func _parse_animation(parser):
	var checkpoint = parser.save_reader_state()
	var with = parser.expect_token("keyword", "with")
	if parser.is_success(with):
		var animation = parser.expect("variable")
		if parser.is_success(animation):
			return animation
		else:
			return parser.error("Expected an animation identifier after with.", 1, checkpoint)
