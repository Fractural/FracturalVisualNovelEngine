extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for a transition


var transition


func _init(transition_, skippable_ = true).(skippable_):
	transition = transition_


func skip():
	transition._on_transition_finished(true)
