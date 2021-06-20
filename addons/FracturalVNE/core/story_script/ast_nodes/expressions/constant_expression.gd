extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("constant expression")
	return arr

func _init(position_).(position_):
	pass

func evaluate():
	pass
