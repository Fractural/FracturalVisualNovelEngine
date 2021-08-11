extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# -- Abstract Class -- #
# Base class for SteppedNodes.
# Stepped nodes are used for nodes that create delays, whether
# by creating a step, waiting for input to progress, or just waiting
# a fixed amount of time.

# Stepped nodes are also expected to add a StepAction to the StoryDirector.
# (Otherwise there is no point in using a stepped node).


# ----- Typable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SteppedNode")
	return arr

# ----- Typable ----- #


# Overriding step allows things like  "together blocks" to 
# run groups of statements on the same step together
var override_step: bool = false


func _init(position_ = null).(position_):
	pass


func execute():
	_finish_execute()


func _finish_execute():
	emit_signal("executed")
	if not override_step:
		get_runtime_block().get_service("StoryDirector").start_step(self)


func is_auto_step():
	return false
