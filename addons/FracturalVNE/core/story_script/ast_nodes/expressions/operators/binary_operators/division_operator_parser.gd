extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator_parser.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("division operator")
	return arr

func get_operators():
	return ["/"]

func get_precedence() -> int:
	return 2

func parse(parser):
	var operator = parser.expect_token("operator", "/")
	if parser.is_success(operator):
		return DivisionOperatorNode.new()
	return operator

class DivisionOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator.gd":
	func evaluate(runtime_manager):
		return left_operand.evaluate(runtime_manager) / right_operand.evaluate(runtime_manager)
