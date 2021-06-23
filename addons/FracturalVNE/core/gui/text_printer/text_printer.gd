extends Node
# Base TextPrinter with signals that allow for the implementation of
# the actual printing functionality. 


# ----- StoryService ----- #

var function_definitions = [
	StoryScriptFuncDef.new("skip"),
	StoryScriptFuncDef.new("say", [
		StoryScriptParameter.new("character"),
		StoryScriptParameter.new("text"),
	], true),
	StoryScriptFuncDef.new("narrate", [
		StoryScriptParameter.new("text"),
	], true)
]


func get_service_name():
	return "TextPrinter"

# ----- StoryService ----- #


const Character = preload("res://addons/FracturalVNE/core/character/character.gd")
const PrintTextAction = preload("res://addons/FracturalVNE/core/gui/text_printer/print_text_action.gd")

signal say(character, text)
signal narrate(text)
signal skip()

export var story_gui_path: NodePath

export var name_default_char_delay: float = 0
export var name_custom_char_delays: Array = []

export var dialogue_default_char_delay: float = 0
export var dialogue_custom_char_delays: Array = []

export var default_name_color: Color = Color.white
export var default_dialogue_color: Color = Color.white

var curr_print_text_action

onready var story_director = get_node(story_gui_path).story_director


func say(character, text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director.add_step_action(curr_print_text_action)
	emit_signal("say", character, text)


func narrate(text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director.add_step_action(curr_print_text_action)
	emit_signal("narrate", text)


func _finished_print_text():
	story_director.remove_step_action(curr_print_text_action)
	curr_print_text_action = null
