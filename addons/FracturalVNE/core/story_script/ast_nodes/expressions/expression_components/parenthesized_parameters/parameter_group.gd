extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"
# Holds a group of parameters.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ParameterGroupNode")
	return arr

# ----- Typeable ----- #


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

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	
	var serialized_parameters = []
	for parameter in parameters:
		serialized_parameters.append(parameter.serialize())
	
	serialized_object["parameters"] = serialized_parameters
	return serialized_object

func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	
	var parameters = []
	for serialized_parameter in serialized_object["parameters"]:
		parameters.append(SerializationUtils.deserialize(serialized_parameter))
	
	instance.parameters = parameters
	return instance

# ----- Serialization ----- #
