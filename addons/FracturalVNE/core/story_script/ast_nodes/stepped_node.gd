extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("stepped")
	return arr

func _init(position).(position):
	pass

func execute():
	emit_signal("executed")
	if runtime_next_node != null:
		runtime_block.get_service("StoryDirector").start_step(funcref(runtime_next_node, "execute"))
