extends Node
# Builds a ChoiceOption for testing.


const FracUtils = FracVNE.Utils
const ChoiceOption = preload("res://addons/FracturalVNE/core/story/choice/choice_option.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_node.gd")

var choice_text: String
var is_valid: bool

var choice_option


func build():
	choice_option = ChoiceOption.new(choice_text, is_valid)
	return choice_option


func inject_is_valid(is_valid_):
	FracUtils.try_free(is_valid)
	is_valid = is_valid_
	return


func inject_choice_text(choice_text_: String):
	choice_text = choice_text_
	return self


func default(direct):
	inject_is_valid(true)
	inject_choice_text("Default choice.")
	return self
