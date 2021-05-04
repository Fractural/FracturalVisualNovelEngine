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
	var services: Dictionary
	# StoryDirector
	var block
	
	func _init(block_).(StoryScriptToken.Position.new(0, 0)):
		block = block_
		block.propagate_call("configure_node", [self])
	
	func propagate_call(method, arguments, parent_first = false):
		if parent_first:
			.propagate_call(method, arguments, parent_first)
		
		block.propagate_call(method, arguments, parent_first)
		
		if not parent_first:
			.propagate_call(method, arguments, parent_first)
	
	func configure_services():
		for service in services.values():
			if service.has_method("configure_service"):
				service.configure_service(self)
	
	func initialize_():
		block.propagate_call("runtime_initialize")
	
	func execute():
		block.execute()
	
	func add_service(name: String, service):
		services[name] = service
	
	func get_service(name: String):
		if services.has(name):
			return services[name]
		return error('Service "%s" could not be found.' % name)
	
	func add_function_holder(new_function_holder):
		if not function_holders.has(new_function_holder):
			function_holders.append(new_function_holder)
	
	func add_function_holders(new_function_holders):
		for new_function_holder in new_function_holders:
			add_function_holder(new_function_holder)
	
	# function_defintions = [
	# 	StoryScriptFuncDef.new("function1_name", [
	#		StoryScriptParameter.new("arg_name1")
	#		StoryScriptParameter.new("arg_name2", 0.1230),
	#		]
	# 	StoryScriptFuncDef.new("function2_name", [
	#		StoryScriptParameter.new("arg_name1", "default")
	#		StoryScriptParameter.new("arg_name2", 0.1230),
	#		]
	# 	StoryScriptFuncDef.new("function3_name", [
	#		StoryScriptParameter.new("arg_name1")
	#		]
	# ]
	#
	# arguments = [
	# 	StoryScriptArgument.new("name", value)
	# 	StoryScriptArgument.new(null, value2)
	# 	StoryScriptArgument.new("name2", value3)
	# ]
	# 
	# TODO Check for variable function_defintions in function_holders
	# and use that to assign appropriate arguments
	
	func call_function(name: String, arguments = []):
		# Only support for native GDScript functions for now
		# User can add custom gdscript functions if they like 
		for holder in function_holders:
			for func_def in holder.function_definitions:
				if func_def.name == name:
					if arguments.size() > func_def.parameters.size():
						return error('Expected at most %s arguments for function "%s()".' % [func_def.parameters.size(), name])
					
					var ordered_args = []
					for param in func_def.parameters:
						ordered_args.append(param.default_value)
					
					for i in range(arguments.size()):
						# If argument name is null, then it must be a positional argument
						if arguments[i].name == null:
							ordered_args[i] = arguments
						else:
							# Else the argument must be a named argument, which means
							# we must lookup the name's index and assign the appropriate 
							# index on ordered_args to the argument's value.
							var param_index = func_def.parameters.find(arguments[i].value)
							if param_index > -1:
								ordered_args[param_index] = arguments[i].value
							else:
								return error('Function "%s()" does not have a named argument "%s".' % [name, arguments[i].name])
					return holder.callv(name, ordered_args)
		return error('Function "%s()" could not be found.' % name)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "PROGRAM:" 
		string += "\n" + tabs_string + "{"
		string += "\n" + block.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
