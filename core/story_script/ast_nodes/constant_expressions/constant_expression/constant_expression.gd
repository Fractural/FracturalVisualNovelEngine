extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression/expression.gd"
# -- Abstract Class -- #
# Base class for all ConstantExpressions.


func get_types() -> Array:
	var arr = .get_types()
	arr.append("ConstantExpression")
	return arr


func _init(position_).(position_):
	pass


func evaluate():
	pass
