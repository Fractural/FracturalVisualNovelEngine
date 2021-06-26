extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression/expression.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("expression component")
	return arr

func _init(position_ = null).(position_):
	pass
