extends "res://addons/FracturalVNE/core/scene/scene_transition.gd"
# Template for scene transitions


func transition(new_scene_: Node, old_scene_: Node, duration_: float):
	.transition(new_scene_, old_scene_, duration_)


func _on_transition_finished(skipped):
	._on_transition_finished(skipped)
