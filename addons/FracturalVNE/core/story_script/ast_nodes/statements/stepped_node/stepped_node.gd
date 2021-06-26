extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("stepped")
	return arr

func _init(position_ = null).(position_):
	pass

func execute():
	emit_signal("executed")
	if not override_step:
		get_runtime_block().get_service("StoryDirector").start_step(self)

# Overriding step allows things like  "together blocks" to 
# run groups of statements on the same step together
var override_step: bool = false
