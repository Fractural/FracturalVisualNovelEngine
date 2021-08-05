extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"


const SceneNode = preload("scene_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("scene")
	return arr


func get_keywords() -> Array:
	return ["scene", "with"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var scene = parser.expect_token("keyword", "scene")
	if parser.is_success(scene):
		var visual = parser.expect("expression")
		if parser.is_success(visual):
			# Parse optional transition.
			var transition = _parse_transition(parser)
			if not parser.is_success(transition):
				return transition
			
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return SceneNode.new(scene.position, visual, transition)
			else:
				return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
		else:
			return parser.error("Expected an expression for the visual after \"scene\".", 1, checkpoint)
	else:
		return parser.error(scene, 0)


func _parse_transition(parser):
	var checkpoint = parser.save_reader_state()
	var with = parser.expect_token("keyword", "with")
	if parser.is_success(with):
		var transition = parser.expect("expression")
		if parser.is_success(transition):
			return transition
		else:
			return parser.error("Expected an expression for the transition after \"with\".", 1, checkpoint)
