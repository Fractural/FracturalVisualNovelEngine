extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/_pre_unary_operator/pre_unary_operator.gd"
# Negates the value of a boolean.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("NegateOperator")
	return arr

# ----- Typeable ----- #Z


func _init(position_ = null, operand_ = null).(position_, operand_):
	pass


func _debug_string_operator_name():
	return "NEGATE"


func evaluate():
	var result = operand.evaluate()
	if not SSUtils.is_success(result):
		return result
	
	if typeof(result) == TYPE_INT:
		return result == 1
	elif typeof(result) == TYPE_BOOL:
		return not result
	return error('Cannot negate type "%s".' % FracUtils.get_type_name(result))
