extends Node

const ProgramNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node.gd")
const SayStatement = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/say_statement.gd")
const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node.gd")

func _process(delta):
	var program = ProgramNode.new(BlockNode.new())
	
	for i in 10:
		program.block.statements.append(SayStatement.new())
	
	program.block._init_post()
	
	program._init_post()
