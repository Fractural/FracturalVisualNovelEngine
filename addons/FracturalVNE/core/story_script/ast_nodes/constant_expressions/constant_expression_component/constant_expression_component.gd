extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component/expression_component.gd"
# -- Abstract Class -- #
# Base class for all ConstantExpressionComponents


func get_types() -> Array:
	var arr = .get_types()
	arr.append("ConstantExpressionComponent")
	return arr


func _init(position_ = null).(position_):
	pass
