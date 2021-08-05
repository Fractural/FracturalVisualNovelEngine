extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node/executable_node.gd"
# -- Abstract Class -- #
# Base class for all StatementNodes.
# Statement nodes run one after another inside of Block statements.


func get_types() -> Array:
	var arr = .get_types()
	arr.append("statement")
	return arr


var overrides_story_flow: bool = false
var runtime_next_node


func _init(position_ = null).(position_):
	pass


func execute():
	_finish_execute()


func _finish_execute():
	emit_signal("executed")
	if runtime_next_node != null:
		runtime_next_node.execute()
