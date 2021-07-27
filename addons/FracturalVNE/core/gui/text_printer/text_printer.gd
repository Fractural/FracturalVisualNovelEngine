extends Node
# Base TextPrinter with signals that allow for the implementation of
# the actual printing functionality. 


# ----- StoryService ----- #

func get_service_name():
	return "TextPrinter"

# ----- StoryService ----- #


const Character = preload("res://addons/FracturalVNE/core/character/character.gd")
const PrintTextAction = preload("res://addons/FracturalVNE/core/gui/text_printer/print_text_action.gd")

signal serialize_state(serialized_state)
signal deserialize_state(serialized_state)
signal say(character, text)
signal narrate(text)
signal skip()

export var name_default_char_delay: float = 0
export var name_custom_char_delays: Array = []

export var dialogue_default_char_delay: float = 0
export var dialogue_custom_char_delays: Array = []

export var default_name_color: Color = Color.white
export var default_dialogue_color: Color = Color.white

export var story_director_dep_path: NodePath

var curr_print_text_action

onready var story_director_dep = get_node(story_director_dep_path)


func say(character, text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director_dep.dependency.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director_dep.dependency.add_step_action(curr_print_text_action)
	emit_signal("say", character, text)


func narrate(text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director_dep.dependency.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director_dep.dependency.add_step_action(curr_print_text_action)
	emit_signal("narrate", text)


func _finished_print_text():
	story_director_dep.dependency.remove_step_action(curr_print_text_action)
	curr_print_text_action = null


# ----- Serialization ----- #

func serialize_state():
	var serialized_state = {
		"service_name": get_service_name(),
	}
	emit_signal("serialize_state", serialized_state)
	return serialized_state


func deserialize_state(serialized_state):
	emit_signal("deserialize_state", serialized_state)

# ----- Serialization ----- #
