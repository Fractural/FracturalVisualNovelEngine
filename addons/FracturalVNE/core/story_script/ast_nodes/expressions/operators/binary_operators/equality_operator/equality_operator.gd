extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/_binary_operator/binary_operator.gd"
# Performs an equality comparison.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("EqualityOperator")
	return arr

# ----- Typeable ----- #


func _init(position_ = null, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
	pass


func _debug_string_operator_name():
	return "EQUALS"


func get_precedence() -> int:
	return 0


func evaluate():
	var left_result = left_operand.evaluate()
	if not SSUtils.is_success(left_result):
		return stack_error(left_result, "Could not perform an equality comparison.")
	var right_result = right_operand.evaluate()
	if not SSUtils.is_success(right_result):
		return stack_error(right_result, "Could not perform an equality comparison.")
	
	return left_result == right_result
