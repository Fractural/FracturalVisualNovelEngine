extends Node

export var story_director_path: NodePath

onready var story_director = get_node(story_director_path)

var history_stack = []

func add_entry(history_entry):
	history_stack.append(history_entry)

# History
# - Decisions
# - Dialogue
# - Only stores history for one scene
# TODO: Finish history

# Can only perform immediate rollback when 

class HistoryEntry:
	pass

class DialogueEntry extends HistoryEntry:
	var character_name: String
	var dialogue_text: String
	
	func _init(character_name_: String, dialogue_text_: String):
		character_name = character_name_
		dialogue_text = dialogue_text_

class DecisionEntry extends HistoryEntry:
	var choice_text: String
	
	func _init(choice_text_: String):
		choice_text = choice_text_
