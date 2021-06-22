extends "res://addons/FracturalVNE/core/story_script/ast_nodes/stepped_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("statement")
	return arr

func _init(position_ = null).(position_):
	pass
