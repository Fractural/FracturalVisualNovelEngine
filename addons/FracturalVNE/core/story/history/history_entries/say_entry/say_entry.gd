extends "res://addons/FracturalVNE/core/story/history/history_entries/history_entry.gd"
# Stores narrated text or dialogue spoken by a character.
# For narrated text the character variable will be null.


var character
var text: String


func _init(character_ = null, text_: String = ""):
	character = character_
	text = text_


# ----- Serialization ----- #

# say_entry_serializer.gd

# ----- Serialization ----- #
