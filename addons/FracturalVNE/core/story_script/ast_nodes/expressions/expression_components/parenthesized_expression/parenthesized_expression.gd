extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator/operator.gd"


var operand


func _init(position_ = null, operand_ = null).(position_):
	operand = operand_


func evaluate():
	return operand.evaluate()


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "PARENTHESES GROUP:"
	string += "\n" + tabs_string + "{"
	string += "\n" + operand.debug_string(tabs_string + "\t")
	string += "\n" + tabs_string + "}"
	return string


# -- StoryScriptErrorable -- #
func propagate_call(method, arguments = [], parent_first = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = operand.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["operand"] = operand.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.operand = SerializationUtils.deserialize(serialized_object["operand"])
	return instance

# ----- Serialization ----- #
