extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node_construct.gd"
# Parses the entire file as a block for a program.


const StoryScriptPosition = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node/block_node.gd")


func get_parse_types() -> Array:
	return ["program block"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var statements = []
	while not parser.is_EOF():
		var statement = parser.expect("Statement")
		if not parser.is_success(statement):
			return parser.error(statement, 1, checkpoint)
		statements.append(statement)
	return BlockNode.new(StoryScriptPosition.new(0, 0), statements)
