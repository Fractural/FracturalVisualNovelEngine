extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator/operator.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("BinaryOperator")
	return arr

# ----- Typeable ----- #


var left_operand
var right_operand


func _init(position_ = null, left_operand_ = null, right_operand_ = null).(position_):
	left_operand = left_operand_
	right_operand = right_operand_


func get_precedence() -> int:
	return 0


func _debug_string_operator_name():
	return "N/A"


func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "OP-" + _debug_string_operator_name() + ":"
	string += "\n" + tabs_string + "{"
	string += "\n" + tabs_string + "\tLEFT:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + left_operand.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "\tRIGHT:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + right_operand.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
	return string


func propagate_call(method: String, arguments: Array = [], parent_first: bool = false):
	var result
	if parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result
	
	result = left_operand.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
			
	result = right_operand.propagate_call(method, arguments, parent_first)
	if not SSUtils.is_success(result):
		return result
	
	if not parent_first:
		result = .propagate_call(method, arguments, parent_first)
		if not SSUtils.is_success(result):
			return result


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["left_operand"] = left_operand.serialize()
	serialized_object["right_operand"] = right_operand.serialize()
	return serialized_object


func deserialize(serialized_object):	
	var instance = .deserialize(serialized_object)
	instance.left_operand = SerializationUtils.deserialize(serialized_object["left_operand"])
	instance.right_operand = SerializationUtils.deserialize(serialized_object["right_operand"])
	return instance

# ----- Serialization ----- #
