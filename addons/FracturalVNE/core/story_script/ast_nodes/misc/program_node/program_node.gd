extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node/executable_node.gd"
# The root node of a story tree. Responsible for starting the program
# and propagating calls to all the nodes.

# Story Tree Execution Order:
# 1. configure_service()
# 2. runtime_initialize() 
# 3. execute()


signal throw_error(error)

const ASTNodeIDDistributor = preload("res://addons/FracturalVNE/core/story_script/story_services/ast_node_id_distributor.gd")

# TODO: Refactor function_holders into just a Dictionary of functions
# to improve lookup speeds
var function_holders: Array = []
var services: Dictionary = {}
var block


func _init(block_ = null).(StoryScriptPosition.new(0, 0)):
	block = block_


func _init_post():
	add_service(ASTNodeIDDistributor.new())
	start_configure_node()


func propagate_call(method, arguments = [], parent_first = false):
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	block.propagate_call(method, arguments, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


func start_configure_node():
	block.propagate_call("configure_node", [self], true)


func start_runtime_initialize():
	block.propagate_call("runtime_initialize")


func execute():
	block.execute()


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
		service.configure_service(self)


func get_service(name: String):
	if services.has(name):
		return services[name]
	return error('Service "%s" could not be found.' % name)


# TODO: Add global variables. Variable functions are currently placeholders.

func has_variable(name: String):
	return false


func get_variable(name: String):
	return StoryScriptError.new('Variable named "%s" could not be found.' % name)


func set_variable(name: String, value):
	StoryScriptError.new('Variable named "%s" could not be found.' % name)


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
# 
# TODO Check for variable function_definitions in function_holders
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

func serialize_state():
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


func deserialize_state(serialized_state):
	for serialized_service_state in serialized_state["services"]:
		services[serialized_service_state["service_name"]].deserialize_state(serialized_service_state)

	propagate_call("deserialize_node_state", [serialized_state["nodes"]])


func serialize():
	var serialized_obj = .serialize()
	serialized_obj["block"] = block.serialize()
	return serialized_obj


func deserialize(serialized_obj):
	var instance = .deserialize(serialized_obj)
	instance.block = SerializationUtils.deserialize(serialized_obj["block"])
	instance._init_post()
	# No need to assign runtime_block since that is assgined at runtime
	return instance

# ----- Serialization ----- #
