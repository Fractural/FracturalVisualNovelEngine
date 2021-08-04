extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/operators/operator/operator_construct.gd"
# -- Abstract Class -- #
# Base class for all BinaryOperatorConstructs.


func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("binary operator")
	return arr


func get_precedence() -> int:
	return 0
