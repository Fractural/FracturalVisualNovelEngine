extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/_binary_operator/binary_operator.gd"
# Perform addition and strign concatenation.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("AdditionOperator")
	return arr

# ----- Typeable ----- #


func _init(position_ = null, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
	pass


func _debug_string_operator_name():
	return "ADD"


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
		# Numerical addition
		return left_result + right_result
	elif typeof(left_result) == TYPE_STRING and typeof(right_result) == TYPE_STRING:
		# String concatnation
		return left_result + right_result
	return error('Cannot add "%s" with "%s".' % [FracUtils.get_type_name(left_result), FracUtils.get_type_name(right_result)])
