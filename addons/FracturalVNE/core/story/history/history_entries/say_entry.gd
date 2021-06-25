extends "res://addons/FracturalVNE/core/story/history/history_entries/history_entry.gd"
# Stores narrated text or dialogue spoken by a character.
# For narrated text the character variable will be null.


var character
var text: String


func _init(character_ = null, text_: String = ""):
	character = character_
	text = text_


# ----- Serialization ----- #

func serialize():
	var serialized_object = {
		"script_path": get_script().get_path(),
		"text": text
	}
	
	if character != null and typeof(character) != TYPE_STRING:
		serialized_object["character_id"] = StoryServiceRegistry.get_service("StoryReferenceRegistry").get_reference_id(character)
	else:
		serialized_object["character_name"] = character
	
	return serialized_object


func deserialize(serialized_object):
	var instance = get_script().new()
	
	if serialized_object.has("character_id"):
		instance.character = StoryServiceRegistry.get_service("StoryReferenceRegistry").get_reference(serialized_object["character_id"])
	else:
		instance.character = serialized_object["character_name"]
	
	instance.text = serialized_object["text"]
	
	return instance

# ----- Serialization ----- #
