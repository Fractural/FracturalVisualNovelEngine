extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for the move statement


var visual_mover


func _init(visual_mover_, skippable_ = true).(skippable_):
	visual_mover = visual_mover_


func skip():
	visual_mover._on_move_finished(true)
