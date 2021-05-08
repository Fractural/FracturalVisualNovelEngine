extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component.gd"

static func get_types():
	var arr = .get_types()
	arr.append("literal")
	return arr

var value

func _init(position_ = null, value_ = null).(position_):
	value = value_

func evaluate():
	return value

func _debug_string_literal_name():
	return "LITERAL"

func debug_string(tabs_string: String) -> String:
	return tabs_string + _debug_string_literal_name() + ": " + str(value)

func get_return_type() -> String:
	return "float"

# ----- Serialization ----- #

func serialize():
	var serialized_obj = .serialize()
	serialized_obj["value"] = value
	return serialized_obj

func deserialize(serialized_obj):	
	var instance = .deserialize(serialized_obj)
	instance.value = serialized_obj["value"]
	return instance

# ----- Serialization ----- #
