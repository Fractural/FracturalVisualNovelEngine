extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component.gd"
# Fetches the value of a variable.


func get_types():
	var arr = .get_types()
	arr.append("VariableNode")
	return arr


var name


func _init(position_ = null, name_ = null).(position_):
	name = name_


func evaluate():
	# Return the variable. If it's an error,
	# it will be also returned as well.
	return get_runtime_block().get_variable(name)


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
