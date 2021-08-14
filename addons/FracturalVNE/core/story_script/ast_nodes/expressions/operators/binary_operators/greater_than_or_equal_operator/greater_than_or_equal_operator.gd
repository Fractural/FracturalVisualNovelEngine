extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/_binary_operator/binary_operator.gd"
# Performs a greater than or equal to comparison.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("GreaterThanOrEqualOperator")
	return arr

# ----- Typeable ----- #


func _init(position_ = null, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
	pass


func _debug_string_operator_name():
	return "GREATER THAN OR EQUAL"


func get_precedence() -> int:
	return 0


func evaluate():
	var left_result = SSUtils.evaluate_and_cast(left_operand, "Number")
	if not SSUtils.is_success(left_result):
		return stack_error(left_result, "Could not perform a greater than or equal to comparison.")
	var right_result = SSUtils.evaluate_and_cast(right_operand, "Number")
	if not SSUtils.is_success(right_result):
		return stack_error(right_result, "Could not perform a greater than or equal to comparison.")
	
	return left_result >= right_result
