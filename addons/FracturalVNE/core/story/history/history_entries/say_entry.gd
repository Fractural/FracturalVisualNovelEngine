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
	var character_id: int
	if character != null:
		character_id = StoryServiceRegistry.get_service("StoryReferenceRegistry").get_reference_id(character)
	else:
		character_id = -1
	
	return {
		"script_path": get_script().get_path(),
		"character_id": character_id,
		"text": text
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	if serialized_object["character_id"] > -1:
		instance.character = StoryServiceRegistry.get_service("StoryReferenceRegistry").get_reference(serialized_object["character_id"])
	instance.text = serialized_object["text"]
	
	return instance

# ----- Serialization ----- #
