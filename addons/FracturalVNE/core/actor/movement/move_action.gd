extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for the move statement


var actor_mover


func _init(actor_mover_, skippable_ = true).(skippable_):
	actor_mover = actor_mover_


func skip():
	actor_mover._on_move_finished(true)
