extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("statement")
	return arr

func overrides_story_flow():
	return false

var runtime_next_node

func _init(position_ = null).(position_):
	pass

func execute():
	emit_signal("executed")
	if runtime_next_node != null:
		runtime_next_node.execute()
