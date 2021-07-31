extends "res://addons/FracturalVNE/core/actor/actor_controller.gd"
# Base TextPrinter with signals that allow for the implementation of
# the actual printing functionality. 


const BaseActorController = preload("res://addons/FracturalVNE/core/actor/actor_controller.gd")
const Character = preload("res://addons/FracturalVNE/core/character/character.gd")
const PrintTextAction = preload("res://addons/FracturalVNE/core/gui/text_printer/print_text_action.gd")

var curr_print_text_action
var story_director


func init(text_printer_ = null, story_director_ = null):
	.init(text_printer_, story_director_)
	story_director = story_director_


func say(character, text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director.add_step_action(curr_print_text_action)


func narrate(text: String, skippable: bool = true):
	if curr_print_text_action != null:
		story_director.remove_step_action(curr_print_text_action)
	
	curr_print_text_action = PrintTextAction.new(self, skippable)
	story_director.add_step_action(curr_print_text_action)


func get_text_printer():
	return get_actor()


func _finished_print_text():
	story_director.remove_step_action(curr_print_text_action)
	curr_print_text_action = null


# ----- Serialization ----- #

# text_printer_controller_serializer.gd

# ----- Serialization ----- #
