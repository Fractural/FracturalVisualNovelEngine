extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression.gd"

var left_operand
var right_operand

func _init(left_operand_ = null, right_operand_ = null):
	left_operand = left_operand_
	right_operand = right_operand_

func _debug_string_operator_name():
	return "OPERATOR"

func debug_string(tabs_string: String):
	var string = ""
	string += tabs_string + "OP-" + _debug_string_operator_name() + " :"
	string += "\n" + tabs_string + "{"
	string += "\n" + tabs_string + "\tLEFT:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + left_operand.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\tRIGHT:"
	string += "\n" + tabs_string + "\t{"
	string += "\n" + right_operand.debug_string(tabs_string + "\t\t")
	string += "\n" + tabs_string + "\t}"
	string += "\n" + tabs_string + "}"
