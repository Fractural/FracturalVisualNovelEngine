extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/_pre_unary_operator/pre_unary_operator.gd"
# Flips the sign of a number.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("FlipSignOperator")
	return arr

# ----- Typeable ----- #Z


func _init(position_ = null, operand_ = null).(position_, operand_):
	pass


func _debug_string_operator_name():
	return "FLIP SIGN"


func evaluate():
	var result = operand.evaluate()
	if not is_success(result):
		return result
	
	if typeof(result) == TYPE_INT or typeof(result) == TYPE_REAL:
		return result * -1
	return error('Cannot flip sign of type "%s".' % FracUtils.get_type_name(result))
