extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var actor_animation


func _init(actor_animation_, skippable_ = true).(skippable_):
	actor_animation = actor_animation_


func skip():
	actor_animation._on_animation_finished(true)
