extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"


var name
var value


func _init(position_ = null, name_ = null, value_ = null).(position_):
	name = name_
	value = value_


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "ARG " + ("_" if name == null else str(name)) + ": "
	string += "\n" + tabs_string + "{"
	string += "\n" + value.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments_: Array = [], parent_first: bool = false):
	if parent_first:
		.propagate_call(method, arguments_, parent_first)
	
	value.propagate_call(method, arguments_, parent_first)
	
	if not parent_first:
		.propagate_call(method, arguments_, parent_first)


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["name"] = name
	serialized_object["value"] = value.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.name = serialized_object["name"]
	instance.value = SerializationUtils.deserialize(serialized_object["value"])
	return instance

# ----- Serialization ----- #
