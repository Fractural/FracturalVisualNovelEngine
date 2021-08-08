extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/_binary_operator/binary_operator_construct.gd"
# Parses an AddOperator.


const AdditionOperator = preload("addition_operator.gd")


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("AdditionOperator")
	return arr


func get_operators():
	return ["+"]


func parse(parser):
	var operator = parser.expect_token("operator", "+")
	if parser.is_success(operator):
		return AdditionOperator.new(operator.position)
	return operator
