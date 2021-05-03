extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression.gd"

static func get_types():
	var arr = .get_types()
	arr.append("operator")
	return arr

func _init(position_).(position_):
	pass
