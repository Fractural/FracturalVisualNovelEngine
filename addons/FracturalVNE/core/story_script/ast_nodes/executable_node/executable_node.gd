extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"

signal executed()

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("executable")
	return arr

func _init(position_ = null).(position_):
	pass

func execute():
	emit_signal("executed")
