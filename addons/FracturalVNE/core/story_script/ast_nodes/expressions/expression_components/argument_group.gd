extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node.gd"

var arguments

func _init(position_ = null, arguments_ = null).(position_):
	arguments = arguments_

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "ARG GROUP:" 
	string += "\n" + tabs_string + "{"
	for argument in arguments:
		string += "\n" + argument.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string

func propagate_call(method: String, arguments_: Array = [], parent_first: bool = false):
	if parent_first:
		.propagate_call(method, arguments_, parent_first)
	
	for argument in arguments:
		argument.propagate_call(method, arguments_, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments_, parent_first)

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	
	var serialized_arguments = []
	for argument in arguments:
		serialized_arguments.append(argument.serialize())
	
	serialized_obj["arguments"] = serialized_arguments
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	
	var arguments = []
	for serialized_argument in serialized_obj["arguments"]:
		arguments.append(SerializationUtils.deserialize(serialized_argument))
	
	instance.arguments = arguments
	return instance

# ----- Serialization ----- #
