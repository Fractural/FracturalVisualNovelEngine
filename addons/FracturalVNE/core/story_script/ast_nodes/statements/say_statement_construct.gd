extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

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
				return SayNode.new(character.position, character, dialogue)
			else:
				return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
		else:
			# If only first expression can be parsed as a string, then 
			# the line must be a narration line
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return SayNode.new(character.position, null, character)
			else:
				return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
	else:
		character = parser.expect("expression")
		if parser.is_success(character):
			var dialogue = parser.expect("string literal")
			if parser.is_success(dialogue):
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return SayNode.new(character.position, character, dialogue)
				else:
					return parser.error("Expected a new line to conclude a statement.", 2/3.0, checkpoint)
			else:
				return parser.error(dialogue, 1/2.0, checkpoint)
		else:
			return character

class SayNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/stepped_node.gd":
	var character
	var text
	
	func _init(position_, character_, text_).(position_):
		character = character_
		text = text_
	
	func execute():
		runtime_block.get_service("TextPrinter").say(self)
		.execute()
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "SAY:" 
		string += "\n" + tabs_string + "{"
		if character != null:
			string += "\n" + tabs_string + "\tCHAR:" 
			string += "\n" + tabs_string + "\t{"
			string += "\n" + character.debug_string(tabs_string + "\t\t")
			string += "\n" + tabs_string + "\t}"
		string += "\n" + tabs_string + "\tTEXT:" 
		string += "\n" + tabs_string + "\t{"
		string += "\n" + text.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"
		string += "\n" + tabs_string + "}"
		return string
