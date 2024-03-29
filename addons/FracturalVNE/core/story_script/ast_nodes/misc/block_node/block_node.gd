
extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node/executable_node.gd"


# ----- Typeabe ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("BlockNode")
	return arr

# ----- Typeabe ----- #


var statements: Array


# ----- Runtime Variables ----- e

var variables: Dictionary
# Overrides the scope of the block to
# use the scope of it's parent block instead.
var override_scope: bool = false

# TODO DISCUSS: Maybe refactor out override_scope since
#				it seems like a hacky way to allow
#				storys to be imported. (Currently
#				the import statement requires the
#				story to use the scope of the import
#				statement in order to give the illusion
#				if pasting in code at the import
#				statement's position)

# ----- Runtime Variables ----- e


func _init(position_ = null, statements_: Array = []).(position_):
	statements = statements_


func configure_node(runtime_block_):
	.configure_node(runtime_block_)
	
	variables = {}
	if statements.size() > 0:
		for i in range(1, statements.size()):
			statements[i - 1].runtime_next_node = statements[i]
	
		# Bind the last statement's executed signal to listen for when the block 
		# is fully executed.
		#
		# Do not bind if the statement overrides the story flow (such as with
		# a jump statement).
		if not statements.back().overrides_story_flow:
			if FracUtils.is_type(statements.back(), "SteppedNode"):
				# Step nodes must wait for the user to step them in order
				# to consider them as finished. This ensures when a stepped
				# node is the last statement, it will only finish the block
				# when the user has stepped it.
				statements.back().connect("stepped", self, "block_executed")
			else:
				statements.back().connect("executed", self, "block_executed")


func execute():
	if statements.size() > 0:
		statements.front().execute()


func block_executed():
	_finish_execute()


func get_service(name: String):
	return get_runtime_block().get_service(name)


func has_variable(name: String):
	if variables.has(name):
		return true
	if get_runtime_block() != null:
		return get_runtime_block().has_variable(name)
	return false


func get_variable(name: String):
	if variables.has(name):
		return variables[name]
	elif get_runtime_block() != null:
		return get_runtime_block().get_variable(name)
	else:
		return error('Variable named "%s" could not be found.' % name)


func set_variable(name: String, value):
	if variables.has(name):
		variables[name] = value
	elif get_runtime_block() != null:
		get_runtime_block().set_variable(name)
	else:
		error('Variable named "%s" could not be found.' % name)


func declare_variable(name: String, value = null):
	if override_scope:
		return get_runtime_block().declare_variable(name, value)
	
	if not variables.has(name):
		var result = value.evaluate()
		if not SSUtils.is_success(result):
			return result
		variables[name] = result
	else:
		return error('Local variable with name "%s" already exists' % name)


# For now only the ProgramNode can call functions. All blocks just pass
# the call_function request to its parent block until it reaches a ProgramNode.
func call_function(name: String, arguments = []):
	return get_runtime_block().call_function(name, arguments)


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "BLOCK:" 
	string += "\n" + tabs_string + "{"
	
	for statement in statements:
		string += "\n" + statement.debug_string(tabs_string + "\t") + ", "
	
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):	
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
		
		# Hijack the arguments of a method
		match method:
			"configure_node":
				arguments = [self]
	
	for statement in statements:
		result = statement.propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize_node_state(saved_nodes):
	var serialized_variables = []
	
	var reference_registry = get_runtime_block().get_service("ReferenceRegistry")
	
	for variable_name in variables.keys():
		var value
		var type
		
		if FracUtils.is_type(variables[variable_name], "Serializable"):
			type = "serializable_object"
			value = reference_registry.get_reference_id(variables[variable_name])
		elif FracUtils.is_type(variables[variable_name], "Resource"):
			type = "resource"
			value = variables[variable_name].get_path()
		elif FracUtils.is_type(variables[variable_name], "Literal"):
			type = "literal"
			value = variables[variable_name]
		else:
			assert(false, "Cannot serialize variable named \"%s\" with type \"%s\"." 
			% [variable_name, FracUtils.get_type_name(variables[variable_name])])
		
		serialized_variables.append({
			"variable_name": variable_name,
			"value": value,
			"type": type,
		})
	
	saved_nodes[str(reference_id)] = {
		"variables": serialized_variables,
	}


func deserialize_node_state(saved_nodes_lookup):
	var reference_registry = get_runtime_block().get_service("ReferenceRegistry")
	var serialized_variables = saved_nodes_lookup[str(reference_id)]["variables"]
	for serialized_variable in serialized_variables:
		match serialized_variable["type"]:
			"resource":
				variables[serialized_variable["variable_name"]] = load(serialized_variable["value"])
			"serializable_object":
				variables[serialized_variable["variable_name"]] = reference_registry.get_reference(serialized_variable["value"])
			"literal":
				variables[serialized_variable["variable_name"]] = serialized_variable["value"]
			_:
				assert(false, "Unrecognized type, \"%s\". Could not deserialize variable." % serialized_variable["type"])


func serialize() -> Dictionary:
	var serialized_object = .serialize()
	
	var serialized_statements = []
	for statement in statements:
		serialized_statements.append(statement.serialize())
	
	serialized_object["statements"] = serialized_statements
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	
	var statements = []
	for serialized_statement in serialized_object["statements"]:
		statements.append(SerializationUtils.deserialize(serialized_statement))
	
	# No need to assign runtime_block since that is assgined at runtime
	instance.statements = statements
	return instance

# ----- Serialization ----- #
