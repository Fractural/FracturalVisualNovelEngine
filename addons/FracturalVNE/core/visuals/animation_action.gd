extends "res://addons/FracturalVNE/core/story/director/step_action.gd"
# Action for animating a Visualr


var visual_animator


func _init(_visual_animator, _skippable).(_skippable):
	visual_animator = _visual_animator


func skip():
	visual_animator.skip_current_animation()
