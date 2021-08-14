extends Node
# Builds a BlockNode for testing.


const FracUtils = FracVNE.Utils
const StoryScriptPosition = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_node.gd")

var position
var statements

var block_node


func build():
	block_node = BlockNode.new(position, statements)
	return block_node


func inject_position(position_):
	FracUtils.try_free(position)
	position = position_
	return self


func inject_statements(statements: Array):
	FracUtils.try_free(statements)
	return self


func default(direct):
	inject_position(StoryScriptPosition.new())
	return self
