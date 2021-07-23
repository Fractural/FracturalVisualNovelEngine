extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator/operator.gd"


static func get_types() -> Array:
	var arr = .get_types()
	arr.append("binary operator")
	return arr


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
	if parent_first:
		.propagate_call(method, arguments, parent_first)
	
	left_operand.propagate_call(method, arguments)
	right_operand.propagate_call(method, arguments)
	
	if not parent_first:
		.propagate_call(method, arguments, parent_first)


# ----- Serialization ----- #

func serialize():
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
