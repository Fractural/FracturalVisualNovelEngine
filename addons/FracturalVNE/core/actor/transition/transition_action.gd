extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# StepAction for transitioning an Actor.


var actor_transition


func _init(actor_transition_, skippable_ = true).(skippable_):
	actor_transition = actor_transition_


func skip():
	actor_transition._on_transition_finished(true)
