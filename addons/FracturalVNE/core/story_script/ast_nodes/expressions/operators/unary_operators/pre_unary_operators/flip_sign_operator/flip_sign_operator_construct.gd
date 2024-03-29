extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/_pre_unary_operator/pre_unary_operator_construct.gd"
# Parses a FlipSignOperator.


const FlipSignOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/flip_sign_operator/flip_sign_operator.gd")


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("FlipSignOperator")
	return arr


func get_operators():
	return ["-"]


func parse(parser):
	var operator = parser.expect_token("operator", "-")
	
	if parser.is_success(operator):
		return FlipSignOperator.new(operator.position)
	return operator
