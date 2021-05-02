extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("subtract operator")
	return arr

func get_operators():
	return ["-"]

func parse(parser):
	var operator = parser.expect_token("operator", "-")
	if parser.is_success(operator):
		return SubtractOperatorNode.new()
	return operator

class SubtractOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator.gd":
	func _debug_string_operator_name():
		return "SUBTRACT"
	
	func get_precedence() -> int:
		return 1
	
	func evaluate(runtime_manager):
		return left_operand.evaluate(runtime_manager) - right_operand.evaluate(runtime_manager)
