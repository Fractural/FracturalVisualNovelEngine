extends Node
# Builds a ChoiceOption for testing.


const FracUtils = FracVNE.Utils
const ChoiceOption = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/choice_statement/choice_option.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_node.gd")

var position = null
var choice_text: String
var block

var choice_option


func build():
	choice_option = ChoiceOption.new(position, choice_text, block)
	return choice_option


func inject_position(position_):
	FracUtils.try_free(position)
	position = position_
	return


func inject_choice_text(choice_text_: String):
	choice_text = choice_text_
	return self


func inject_block(block_):
	FracUtils.try_free(block)
	block = block_
	return self


func default(direct):
	inject_position(FracVNE.StoryScript.Position.new())
	inject_block(direct.script_blank(BlockNode).double())
	inject_choice_text("Default choice.")
	return self
