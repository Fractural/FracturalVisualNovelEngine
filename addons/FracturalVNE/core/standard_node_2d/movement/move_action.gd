extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for the move statement


var standard_node_2d_mover


func _init(standard_node_2d_mover_, skippable_ = true).(skippable_):
	standard_node_2d_mover = standard_node_2d_mover_


func skip():
	standard_node_2d_mover._on_move_finished(true)
