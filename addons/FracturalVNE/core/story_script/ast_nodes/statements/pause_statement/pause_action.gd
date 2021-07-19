extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var pause_statement


func _init(pause_statement_, skippable_ = true).(skippable_):
	pause_statement = pause_statement_


func skip():
	pause_statement._on_pause_finished(true)
