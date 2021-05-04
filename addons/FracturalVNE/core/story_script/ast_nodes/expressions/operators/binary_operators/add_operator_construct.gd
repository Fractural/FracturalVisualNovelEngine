extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("add operator")
	return arr

func get_operators():
	return ["+"]

func parse(parser):
	var operator = parser.expect_token("operator", "+")
	if parser.is_success(operator):
		return AddOperatorNode.new(operator.position)
	return operator
	
class AddOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/binary_operators/binary_operator.gd":
	func _init(position_, left_operand_ = null, right_operand_ = null).(position_, left_operand_, right_operand_):
		pass
	
	func _debug_string_operator_name():
		return "ADD"
	
	func get_precedence() -> int:
		return 1
	
	func evaluate():
		return left_operand.evaluate() - right_operand.evaluate()
