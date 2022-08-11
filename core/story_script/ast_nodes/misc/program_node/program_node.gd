extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node/executable_node.gd"
# The root node of a story tree. Responsible for starting the program
# and propagating calls to all the nodes.

# Story Abstract Syntax Tree Call Order:
# 1. 	program_node	configure_service()
# 2. 	program_node	configure_node() for main nodes
# 3. 	program_node	runtime_initialize() 
# 4.		import_node		configure_node()
# 5.		import_node		runtime_initialize()
# 6.			imported_import_node	configure_node()
# 7.			imported_import_node	runtime_initialize() 
# 8.				...
# 9.				...
# 10.	program_node	execute()

# Note that all stored references to statements/things within an AST
# should be WeakRefs. This is to allow the StoryManager to free the AST tree
# when it is no longer needed.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ProgramNode")
	return arr

# ----- Typeable ----- #


signal throw_error(error)

const ASTNodeIDDistributor = preload("res://addons/FracturalVNE/core/story_script/story_services/ast_node_id_distributor.gd")

# TODO DISCUSS: Maybe refactor function_holders into just a Dictionary of functions
# to improve lookup speeds
var function_holders: Array = []
var services: Dictionary = {}
var block


func _init(block_ = null).(StoryScriptPosition.new(0, 0)):
	block = block_


# -- StoryScriptErrorable -- #
# Called after initialization
func _init_post():
	block.set_runtime_block(self)
	add_service(ASTNodeIDDistributor.new())
	var result = start_configure_node()
	if not SSUtils.is_success(result):
		return result


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = block.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# -- StoryScriptErorrable -- #
func start_configure_node():
	return block.propagate_call("configure_node", [self], true)


# -- StoryScriptErrorable -- #
func start_runtime_initialize():
	return block.propagate_call("runtime_initialize")


func execute():
	get_service("StoryDirector").curr_stepped_node = self
	block.execute()


# -- StoryScriptErrorable -- #
func add_service(service, name = null):
	if name == null:
		name = service.get_service_name()
	if typeof(name) != TYPE_STRING:
		assert(false, "Service name must be string.")
	services[name] = service
	
	# Adds the service as a function holder if it has function definitions
	if "function_definitions" in service:
		add_function_holder(service)
	
	if service.has_method("configure_service"):
		var result = service.configure_service(self)
		if not SSUtils.is_success(result):
			return result


func get_service(name: String):
	if services.has(name):
		return services[name]
	return error('Service "%s" could not be found.' % name)


# TODO: Add global variables. Variable functions are currently placeholders.

func has_variable(name: String):
	return false


func get_variable(name: String):
	return SSUtils.error('Variable named "%s" could not be found.' % name)


func set_variable(name: String, value):
	SSUtils.error('Variable named "%s" could not be found.' % name)


func add_function_holder(new_function_holder):
	if not function_holders.has(new_function_holder):
		function_holders.append(new_function_holder)


func add_function_holders(new_function_holders):
	for new_function_holder in new_function_holders:
		add_function_holder(new_function_holder)


# arguments = [
# 	StoryScriptArgument.new("name", value)
# 	StoryScriptArgument.new(null, value2)
# 	StoryScriptArgument.new("name2", value3)
# ]

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
						ordered_args[i] = arguments[i].value
					else:
						# Else the argument must be a named argument, which means
						# we must lookup the name's index and assign the appropriate 
						# index on ordered_args to the argument's value.
						var param_index: int = -1
						for j in func_def.parameters.size():
							if func_def.parameters[j].name == arguments[i].name:
								param_index = j
								break
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


func throw_error(error):
	emit_signal("throw_error", error)


# ----- Serialization ----- #

func serialize_state() -> Dictionary:
	var serialized_node_states = {}
	propagate_call("serialize_node_state", [serialized_node_states])
	
	var serialized_service_states = []
	for service in services.values():
		if service.has_method("serialize_state"):
			serialized_service_states.append(service.serialize_state())
	
	return { 
		"nodes": serialized_node_states,
		"services": serialized_service_states,
	}


func deserialize_state(serialized_state) -> void:
	for serialized_service_state in serialized_state["services"]:
		services[serialized_service_state["service_name"]].deserialize_state(serialized_service_state)

	propagate_call("deserialize_node_state", [serialized_state["nodes"]])

# ----- Serialization ----- #
