extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var visual_animation


func _init(visual_animation_, skippable_ = true).(skippable_):
	visual_animation = visual_animation_


func skip():
	visual_animation._on_animation_finished(true)
