extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/stepped_node/stepped_node.gd"
# AST Node that prints text said by a character or, if there is no character 
# speaking, prints text as narration.


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("say")
	return arr

# ----- Typeable ----- #


const SayEntry = preload("res://addons/FracturalVNE/core/story/history/history_entries/say_entry/say_entry.gd")

var character
var text


func _init(position_ = null, character_ = null, text_ = null).(position_):
	character = character_
	text = text_


func execute():
	var text_printer = get_runtime_block().get_service("TextPrinter")
	var history_manager = get_runtime_block().get_service("HistoryManager")
	
	if character == null:
		text_printer.narrate(text)
		history_manager.add_entry(SayEntry.new(null, text))
	else:
		var character_result = character.evaluate()
		if not is_success(character_result):
			throw_error(character_result)
			return
		text_printer.say(character_result, text)
		history_manager.add_entry(SayEntry.new(character_result, text))
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
