extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component.gd"

func get_types():
	var arr = .get_types()
	arr.append("variable")
	return arr

var name

func _init(position_ = null, name_ = null).(position_):
	name = name_

func evaluate():
	var variable = get_runtime_block().get_variable(name)
	if is_success(variable):
		return variable
	return stack_error(variable)

func debug_string(tabs_string: String) -> String:
	return tabs_string + "VAR: " + name

# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["name"] = name
	return serialized_object

func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.name = serialized_object["name"]
	return instance

# ----- Serialization ----- #
