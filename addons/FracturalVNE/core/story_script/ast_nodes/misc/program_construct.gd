extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_construct.gd").BlockNode
const ProgramNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node.gd")

func get_parse_types() -> Array:
	return ["program"]

func get_keywords() -> Array:
	return ["program"]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var statements = []
	while not parser.is_EOF():
		var statement = parser.expect("statement")
		if not parser.is_success(statement):
			return parser.error(statement, 1, checkpoint)
		statements.append(statement)
	return ProgramNode.new(BlockNode.new(StoryScriptPosition.new(0, 0), statements))
