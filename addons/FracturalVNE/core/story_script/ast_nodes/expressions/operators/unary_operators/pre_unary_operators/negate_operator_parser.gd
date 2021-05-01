extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator_parser.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("negate operator")
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
		return NegateOperatorNode.new()
	return parser

class NegateOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator.gd":
	func evaluate(runtime_manager):
		return operand
