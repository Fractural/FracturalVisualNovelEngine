extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("stepped")
	return arr

func _init(position).(position):
	pass
