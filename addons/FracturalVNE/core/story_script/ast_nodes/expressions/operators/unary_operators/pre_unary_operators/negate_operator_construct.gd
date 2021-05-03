extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("negate operator")
	return arr

func get_keywords():
	return ["not"]

func get_operators():
	return ["!"]

func parse(parser):
	var operator = parser.expect_token("operator", "!")
	
	if not parser.is_success(operator):
		operator = parser.expect_token("keyword", "not")
	
	if parser.is_success(operator):
		return NegateOperatorNode.new(operator.position)
	return operator

class NegateOperatorNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/unary_operators/pre_unary_operators/pre_unary_operator.gd":
	func _init(position_, operand_ = null).(position_, operand_):
		pass
	
	func _debug_string_operator_name():
		return "NEGATE"
	
	func evaluate(runtime_manager):
		return operand
