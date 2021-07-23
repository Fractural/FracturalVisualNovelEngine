extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/_binary_operator/binary_operator.gd"

# TODO: Rename "division_operator" to "divide_operator"

func _init(position_ = null, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
	pass

func _debug_string_operator_name():
	return "DIVIDE"

func get_precedence() -> int:
	return 2

func evaluate():
	var left_result = left_operand.evaluate()
	if not is_success(left_result):
		return left_result
	var right_result = right_operand.evaluate()
	if not is_success(right_result):
		return right_result
	
	if (typeof(left_result) == TYPE_INT or typeof(left_result) == TYPE_REAL) and (typeof(right_result) == TYPE_INT or typeof(right_result) == TYPE_REAL):
		return left_result / right_result
	return error('Cannot divide "%s" by "%s".' % [FracVNE.Utils.get_type_name(left_result), FracVNE.Utils.get_type_name(right_result)])
