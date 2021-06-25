extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/expression_component.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("constant expression component")
	return arr

func _init(position_ = null).(position_):
	pass
