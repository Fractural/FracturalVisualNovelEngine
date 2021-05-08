extends "res://addons/FracturalVNE/core/story_script/ast_nodes/stepped_node.gd"

var character
var text

func _init(position_ = null, character_ = null, text_ = null).(position_):
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
	string += "\n" + tabs_string + "\t\t" + text
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
	return string

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
