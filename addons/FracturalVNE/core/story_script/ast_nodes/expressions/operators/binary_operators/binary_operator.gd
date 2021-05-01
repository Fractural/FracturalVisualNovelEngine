extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression.gd"

var left_operand
var right_operand

func _init(left_operand_ = null, right_operand_ = null):
	left_operand = left_operand_
	right_operand = right_operand_
