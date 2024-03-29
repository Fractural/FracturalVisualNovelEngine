extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses a show statement.


const ShowNode = preload("show_statement.gd")
const MultiVisualShowNode = preload("multi_visual_show_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("ShowStatement")
	return arr


func get_keywords() -> Array:
	return ["show", "with"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var show = parser.expect_token("keyword", "show")
	if parser.is_success(show):
		var visual = parser.expect("Expression")
		if parser.is_success(visual):
			var modifier_identifier = parser.expect_token("identifier")
			if parser.is_success(modifier_identifier):
				# We are parsing a multi visual show statement here.
				var modifiers_string = modifier_identifier.symbol + " "
				modifier_identifier = parser.expect_token("identifier")
				while parser.is_success(modifier_identifier):
					modifiers_string += modifier_identifier.symbol + " "
					modifier_identifier = parser.expect_token("identifier")
				# Remove the space at the end of the string
				modifiers_string = modifiers_string.substr(0, modifiers_string.length() - 1)
				
				# Parse optional transition.
				var transition = _parse_transition(parser)
				if not parser.is_success(transition):
					return transition
				
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return MultiVisualShowNode.new(show.position, visual, modifiers_string, transition)
				else:
					return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
			else:
				# We are parsing a normal show statement here.
				
				# Parse optional transition.
				var transition = _parse_transition(parser)
				if not parser.is_success(transition):
					return transition
				
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return ShowNode.new(show.position, visual, transition)
				else:
					return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
		else:
			# Confidence of 1 because we are confident once we parsed 
			# the show keyword, we are trying to parse a show statement.
			return parser.error("Expected an expression for the visual after \"show\".", 1, checkpoint)
	else:
		return parser.error(show, 0)


func _parse_transition(parser):
	var checkpoint = parser.save_reader_state()
	var with = parser.expect_token("keyword", "with")
	if parser.is_success(with):
		var transition = parser.expect("Expression")
		if parser.is_success(transition):
			return transition
		else:
			return parser.error("Expected an expression for the transition after \"with\".", 1, checkpoint)
