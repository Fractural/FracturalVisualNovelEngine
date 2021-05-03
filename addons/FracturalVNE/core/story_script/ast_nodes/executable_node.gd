extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("executable")
	return arr

func _init(position).(position):
	pass

func execute():
	pass
