extends "res://addons/FracturalVNE/core/story_script/ast_nodes/stepped_statement_node.gd"

var character
var text

func _init(position_ = null, character_ = null, text_ = null).(position_):
	character = character_
	text = text_

func execute():
	var text_printer = runtime_block.get_service("TextPrinter")
	
	if character == null:
		text_printer.narrate(text)
	else:
		var result = character.evaluate()
		if not is_success(result):
			throw_error(result)
			return
		text_printer.say(result, text)
	
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
	string += "\n" + tabs_string + "\t\t" + text
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
	return string

func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	if character != null:
		character.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	if character != null:
		serialized_obj["character"] = character.serialize()
	serialized_obj["text"] = text
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	if serialized_obj.has("character"):
		instance.character = SerializationUtils.deserialize(serialized_obj["character"])
	instance.text = serialized_obj["text"]
	return instance

# ----- Serialization ----- #
