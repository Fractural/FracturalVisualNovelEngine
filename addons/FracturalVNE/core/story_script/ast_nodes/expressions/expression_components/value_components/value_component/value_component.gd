extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component/expression_component.gd"
# -- Abstract Class -- #
# Base class for all ValueComponents.
# Value components are the smallest piece of an expression.
# Each value component represents a value, whether from a function,
# from a variable, etc.


func get_types() -> Array:
	var arr = .get_types()
	arr.append("value component")
	return arr


func _init(position_ = null).(position_):
	pass
