extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression/expression.gd"
# -- Abstract Class -- #
# Base class for ExpressionComponents.
# Expression components are the second smallest piece of an expression.
# Expression components contain unary operators which wrap around
# a ValueComponent -- the smallest piece of an expression.


func get_types() -> Array:
	var arr = .get_types()
	arr.append("ExpressionComponent")
	return arr


func _init(position_ = null).(position_):
	pass
