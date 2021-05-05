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
		return SubtractOperatorNode.new(operator.position)
	return operator

class SubtractOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator.gd":
	func _init(position_, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
		pass
	
	func _debug_string_operator_name():
		return "SUBTRACT"
	
	func get_precedence() -> int:
		return 1
	
	func evaluate():
		var left_result = left_operand.evaluate()
		if not is_success(left_result):
			return left_result
		var right_result = right_operand.evaluate()
		if not is_success(right_result):
			return right_result
		
		if (typeof(left_result) == TYPE_INT or typeof(left_result) == TYPE_REAL) and (typeof(right_result) == TYPE_INT or typeof(right_result) == TYPE_REAL):
			return left_result - right_result
		return error('Cannot subtract "%s" by "%s".' % [FracturalUtils.get_type_name(left_result), FracturalUtils.get_type_name(right_result)])
