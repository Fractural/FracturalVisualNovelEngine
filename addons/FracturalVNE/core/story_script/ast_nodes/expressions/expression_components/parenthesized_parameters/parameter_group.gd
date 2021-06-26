extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"

var parameters

func _init(position_ = null, parameters_ = null).(position_):
	parameters = parameters_

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "PARAM GROUP:" 
	string += "\n" + tabs_string + "{"
	for param in parameters:
		string += "\n" + tabs_string + "\t" + str(param) + ","
	string += "\n" + tabs_string + "}"
	return string

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	
	var serialized_parameters = []
	for parameter in parameters:
		serialized_parameters.append(parameter.serialize())
	
	serialized_obj["parameters"] = serialized_parameters
	return serialized_obj

func deserialize(serialized_obj):
	var instance = .deserialize(serialized_obj)
	
	var parameters = []
	for serialized_parameter in serialized_obj["parameters"]:
		parameters.append(SerializationUtils.deserialize(serialized_parameter))
	
	instance.parameters = parameters
	return instance

# ----- Serialization ----- #
