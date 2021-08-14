extends Node
# Builds a ChoiceStatement for testing.


const FracUtils = FracVNE.Utils
const ChoiceStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/choice_statement/choice_statement.gd")

var position = null
var choice_blocks: Array = []

var choice_statement


func build():
	choice_statement = ChoiceStatement.new(position)
	return choice_statement


func inject_position(position_):
	FracUtils.try_free(position)
	position = position_
	return self


func inject_choice_blocks(choice_blocks_: Array):
	FracUtils.try_free(choice_blocks)
	choice_blocks = choice_blocks_


func default(direct):
	inject_position(null)
	return self
