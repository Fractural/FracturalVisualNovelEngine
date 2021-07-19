extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var pause_node


func _init(_pause_node, _skippable).(_skippable):
	pause_node = _pause_node


func skip():
	pause_node._on_pause_finished(true)
