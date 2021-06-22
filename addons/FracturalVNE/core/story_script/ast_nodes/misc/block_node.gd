
extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd"

static func get_types() -> Array:
	return ._get_added_types(["block"])

var statements: Array

# Runtime variables
var variables: Dictionary

func _init(position_ = null, statements_: Array = []).(position_):
	statements = statements_

func _init_post():
	variables = {}
	if statements.size() > 0:
		statements.front().runtime_block = self
		for i in range(1, statements.size()):
			statements[i].runtime_block = self
			statements[i - 1].runtime_next_node = statements[i]
	
	# Bind the last statement's executed signal to listen
	# for when the block is fully executed
	statements.back().connect("executed", self, "block_completed")

func execute():
	statements.front().execute()

func block_completed():
	.execute()

func get_service(name: String):
	return runtime_block.get_service(name)

func has_variable(name: String):
	return variables.has(name)

func get_variable(name: String):
	if variables.has(name):
		return variables[name]
	return StoryScriptError.new('Variable named "%s" could not be found.' % name)

# TODO NOW: Add saving for block_node's variables

func set_variable(name: String, value):
	if variables.has(name):
		variables[name] = value
	else:
		StoryScriptError.new('Variable named "%s" could not be found.' % name)

func declare_variable(name: String, value = null):
	if not variables.has(name):
		variables[name] = value
	else:
		return error('Local variable with name "%s" already exists' % name)

# For now only the ProgramNode can call functions. All blocks just pass
# the call_function request to its parent block until it reaches a ProgramNode.
func call_function(name: String, arguments = []):
	return runtime_block.call_function(name, arguments)

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "BLOCK:" 
	string += "\n" + tabs_string + "{"
	
	for statement in statements:
		string += "\n" + statement.debug_string(tabs_string + "\t") + ", "
	
	string += "\n" + tabs_string + "}"
	return string

func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	if parent_first:
		.propagate_call(method, arguments, parent_first)
		
		# Hijack the arguments of a method
		match method:
			"configure_node":
				arguments = [self]
	
	for statement in statements:
		statement.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)

# ----- Serialization ----- #

func serialize_save(saved_nodes):
	var serialized_variables = []
	for variable_name in variables.keys():
		serialized_variables.append({
			"variable": variable_name,
			"value": variables[variable_name],
		})
	
	saved_nodes[reference_id] = {
		"variables:": serialized_variables,
	}

func deserialize_save(saved_nodes_lookup):
	var serialized_variables = saved_nodes_lookup[reference_id]["variables"]
	for serialized_variable_name in serialized_variables.keys():
		variables[serialized_variable_name] = serialized_variables[serialized_variable_name]

func serialize():
	var serialized_obj = .serialize()
	
	var serialized_statements = []
	for statement in statements:
		serialized_statements.append(statement.serialize())
	
	serialized_obj["statements"] = serialized_statements
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	
	var statements = []
	for serialized_statement in serialized_obj["statements"]:
		statements.append(SerializationUtils.deserialize(serialized_statement))
	
	# No need to assign runtime_block since that is assgined at runtime
	instance.statements = statements
	instance._init_post()
	return instance

# ----- Serialization ----- #
