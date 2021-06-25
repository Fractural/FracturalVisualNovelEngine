extends "res://addons/FracturalVNE/core/story/history/history_entries/history_entry.gd"
# Stores a decision made by the player


var choice_text: String


func _init(choice_text_: String):
	choice_text = choice_text_
