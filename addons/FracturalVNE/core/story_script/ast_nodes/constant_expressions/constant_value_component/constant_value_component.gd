extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_components/value_component/value_component.gd"


func get_types() -> Array:
	var arr = .get_types()
	arr.append("ConstantValueComponent")
	return arr


func _init(position_ = null).(position_):
	pass
