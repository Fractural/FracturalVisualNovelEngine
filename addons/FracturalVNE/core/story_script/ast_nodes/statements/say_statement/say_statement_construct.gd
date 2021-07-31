extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/stepped_node/stepped_node_construct.gd"
# Parses a say statement in a story script.

# TODO: Add support for specifying the printer to print in


const SayNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/say_statement/say_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("say")
	return arr


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var character = parser.expect("string literal")
	if parser.is_success(character):
		var dialogue = parser.expect("string literal")
		if parser.is_success(dialogue):
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return SayNode.new(character.position, character, dialogue.evaluate())
			else:
				return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
		else:
			# If only first expression can be parsed as a string, then 
			# the line must be a narration line
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return SayNode.new(character.position, null, character.evaluate())
			else:
				return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
	else:
		character = parser.expect("expression")
		if parser.is_success(character):
			var dialogue = parser.expect("string literal")
			if parser.is_success(dialogue):
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return SayNode.new(character.position, character, dialogue.evaluate())
				else:
					return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
			else:
				return parser.error(dialogue, 1/2.0, checkpoint)
		else:
			return character
