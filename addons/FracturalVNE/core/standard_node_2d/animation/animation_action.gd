extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var standard_node_2d_animation


func _init(standard_node_2d_animation_, skippable_ = true).(skippable_):
	standard_node_2d_animation = standard_node_2d_animation_


func skip():
	standard_node_2d_animation._on_animation_finished(true)
