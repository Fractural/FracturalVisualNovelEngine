extends "res://addons/FracturalVNE/core/story_script/ast_nodes/constant_expressions/constant_value_component/constant_value_component.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("Literal")
	return arr

# ----- Typeable ----- #


var value


func _init(position_ = null, value_ = null).(position_):
	value = value_


func evaluate():
	return value


func _debug_string_literal_name():
	return "LITERAL"


func debug_string(tabs_string: String) -> String:
	return tabs_string + _debug_string_literal_name() + ": " + str(value)


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["value"] = value
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.value = serialized_object["value"]
	return instance

# ----- Serialization ----- #
