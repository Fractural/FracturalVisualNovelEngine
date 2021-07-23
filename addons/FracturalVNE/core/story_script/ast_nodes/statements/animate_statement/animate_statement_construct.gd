extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"

const AnimateStatement = preload("animate_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("animate")
	return arr


func get_keywords() -> Array:
	return ["animate", "with"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var animate = parser.expect_token("keyword", "animate")
	if parser.is_success(animate):
		var visual = parser.expect("expression")
		if parser.is_success(visual):
			# Parse optional animation.
			var animation = _parse_animation(parser)
			if not parser.is_success(animation):
				return animation
			
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return AnimateStatement.new(animate.position, visual, animation)
			else:
				return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
		else:
			return parser.error("Expected an expression for the visual after \"animate\".", 1, checkpoint)
	else:
		return parser.error(animate, 0)


func _parse_animation(parser):
	var checkpoint = parser.save_reader_state()
	var with = parser.expect_token("keyword", "with")
	if parser.is_success(with):
		var animation = parser.expect("expression")
		if parser.is_success(animation):
			return animation
		else:
			return parser.error("Expected an expression for the animation after \"with\".", 1, checkpoint)
