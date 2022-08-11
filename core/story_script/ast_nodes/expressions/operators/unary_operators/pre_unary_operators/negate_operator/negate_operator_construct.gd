extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/_pre_unary_operator/pre_unary_operator_construct.gd"
# Parses a NegateOperator.

const NegateOperator = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/negate_operator/negate_operator.gd")


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("NegateOperator")
	return arr


func get_keywords():
	return ["not"]


func get_operators():
	return ["!"]


func parse(parser):
	var operator = parser.expect_token("operator", "!")
	
	if not parser.is_success(operator):
		operator = parser.expect_token("keyword", "not")
	
	if parser.is_success(operator):
		return NegateOperator.new(operator.position)
	return operator
