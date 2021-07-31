extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component/expression_component.gd"

func get_types() -> Array:
	var arr = .get_types()
	arr.append("value component")
	return arr

func _init(position_ = null).(position_):
	pass
