extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node.gd"
# -- Abstract Class -- #
# Base class for all ExecutableNodes.
# Executable nodes can execute something and calls executed 
# once execution has finished.


signal executed()


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ExecutableNode")
	return arr

# ----- Typeable ----- #


func _init(position_ = null).(position_):
	pass


func execute():
	_finish_execute()


func _finish_execute():
	emit_signal("executed")
