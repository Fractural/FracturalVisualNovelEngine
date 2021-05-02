extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator.gd"

var operand

func _init(operand_ = null):
	operand = operand_

func _debug_string_operator_name():
	return "OPERATOR"

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "OP-" + _debug_string_operator_name() + ":"
	string += "\n" + tabs_string + "{"
	string += "\n" + operand.debug_string(tabs_string + "\t")	
	string += "\n" + tabs_string + "}"
	return string
