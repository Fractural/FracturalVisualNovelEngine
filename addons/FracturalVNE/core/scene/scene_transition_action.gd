extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for loading a new scene


var scene_transition


func _init(scene_transition_, skippable_ = true).(skippable_):
	scene_transition = scene_transition_


func skip():
	scene_transition._on_transition_finished(true)
