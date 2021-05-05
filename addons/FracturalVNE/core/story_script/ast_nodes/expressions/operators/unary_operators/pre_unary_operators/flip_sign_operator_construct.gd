extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("flip sign operator")
	return arr

func get_operators():
	return ["-"]

func parse(parser):
	var operator = parser.expect_token("operator", "-")
	
	if parser.is_success(operator):
		return FlipSignOperatorNode.new(operator.position)
	return operator

class FlipSignOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator.gd":
	func _init(position_, operand_ = null).(position_, operand_):
		pass
	
	func _debug_string_operator_name():
		return "FLIP SIGN"
	
	func evaluate():
		var result = operand.evaluate()
		if not is_success(result):
			return result
		
		if typeof(result) == TYPE_INT or typeof(result) == TYPE_REAL:
			return result * -1
		return error('Cannot flip sign of type "%s".' % FracturalUtils.get_type_name(result))
