extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/stepped_node/stepped_node.gd"
# AST Node that prints text said by a character or, if there is no character 
# speaking, prints text as narration.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SayStatement")
	return arr

# ----- Typeable ----- #


const SayEntry = preload("res://addons/FracturalVNE/core/story/history/history_entries/say_entry/say_entry.gd")

var character 	# Node
var text 		# String
var printer 	# Node


func _init(position_ = null, character_ = null, text_ = null, printer_ = null).(position_):
	character = character_
	text = text_
	printer = printer_


func execute():
	var text_printer_controller
	if printer == null:
		text_printer_controller = get_runtime_block().get_service("TextPrinterManager").get_default_text_printer_controller()
	var history_manager = get_runtime_block().get_service("HistoryManager")
	
	if text_printer_controller == null:
		throw_error(error("Printer does not exist for the say statement."))
		return
	
	if character == null:
		text_printer_controller.narrate(text)
		history_manager.add_entry(SayEntry.new(null, text))
	else:
		var character_result = SSUtils.evaluate_and_cast(character, "Character")
		if not is_success(character_result):
			character_result = SSUtils.evaluate_and_cast(character, "String")
			if not is_success(character_result):
				throw_error(stack_error(character_result, "Could not evaluate the character for the say statement."))
				return
		text_printer_controller.say(character_result, text)
		history_manager.add_entry(SayEntry.new(character_result, text))
	
	_finish_execute()


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
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if character != null:
		result = character.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
		
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	if character != null:
		serialized_object["character"] = character.serialize()
	serialized_object["text"] = text
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	if serialized_object.has("character"):
		instance.character = SerializationUtils.deserialize(serialized_object["character"])
	instance.text = serialized_object["text"]
	return instance

# ----- Serialization ----- #
