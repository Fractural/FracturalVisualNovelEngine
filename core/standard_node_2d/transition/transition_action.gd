extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for transitioning an Actor.


var standard_node_2d_transition


func _init(standard_node_2d_transition_, skippable_ = true).(skippable_):
	standard_node_2d_transition = standard_node_2d_transition_


func skip():
	standard_node_2d_transition._on_transition_finished(true)
