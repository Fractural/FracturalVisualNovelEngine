extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_construct.gd").BlockNode

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
	return ProgramNode.new(BlockNode.new(StoryScriptToken.Position.new(0, 0), statements))
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class ProgramNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var function_holders: Array
	var block
	
	func _init(block_).(StoryScriptToken.Position.new(0, 0)):
		block = block_
		block.runtime_block = self
	
	func execute(runtime_manager):
		block.execute(runtime_manager)
	
	func add_function_holders(new_function_holders):
		for new_holder in new_function_holders:
			if not function_holders.has(new_holder):
				function_holders.append(new_holder)
	
	func call_function(name: String, arguments = []):
		# Only support for native GDScript functions for now
		# User can add custom gdscript functions if they like 
		for holder in function_holders:
			if holder.has_method(name):
				return holder.callv(name, arguments)
		return StoryScriptError.new('Function named "%s" could not be found.' % name)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "PROGRAM:" 
		string += "\n" + tabs_string + "{"
		string += "\n" + block.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
