extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("binary operator")
	return arr

var left_operand
var right_operand

func _init(position_, left_operand_ = null, right_operand_ = null).(position_):
	left_operand = left_operand_
	right_operand = right_operand_

func get_precedence() -> int:
	return 0

func _debug_string_operator_name():
	return "OPERATOR"

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
