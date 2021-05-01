extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator_parser.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("flip sign operator")
	return arr

func get_operators():
	return ["-"]

func parse(parser):
	var operator = parser.expect_token("operator", "-")
	
	if parser.is_success(operator):
		return FlipSignOperatorNode.new()
	return parser

class FlipSignOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator.gd":
	func evaluate(runtime_manager):
		return operand * -1
