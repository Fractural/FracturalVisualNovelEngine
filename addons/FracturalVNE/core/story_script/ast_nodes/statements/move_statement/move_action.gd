extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for the move statement


var move_statement


func _init(move_statement_, skippable_ = true).(skippable_):
	move_statement = move_statement_


func skip():
	move_statement._on_movement_finished(true)
