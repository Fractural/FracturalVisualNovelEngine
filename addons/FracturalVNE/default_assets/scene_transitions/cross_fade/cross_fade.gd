extends "res://addons/FracturalVNE/core/scene/scene_transition.gd"
# Scene transition that crossfades between two scenes


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("CrossFadeSceneTransition")
	return arr

# ----- Typeable ----- #


enum State {
	IDLE,
	FADE_IN,
	FADE_OUT
}

export var new_scene_holder_path: NodePath
export var old_scene_holder_path: NodePath
export var fade_in_curve: Curve
export var fade_out_curve: Curve

var time: float
var state: int
var old_scene_original_parent: Node
var new_scene_original_parent: Node

onready var old_scene_holder = get_node(new_scene_holder_path)
onready var new_scene_holder = get_node(old_scene_holder_path)


func _process(delta):
	match state:
		State.FADE_IN:
			if time < duration / 2:
				time += delta
				new_scene_holder.modulate.a = fade_in_curve.interpolate(time / duration)
			else:
				old_scene.visible = false
				new_scene.visible = true
				state = State.FADE_OUT
				time = 0
		State.FADE_OUT:
			if time < duration / 2:
				time += delta
				new_scene_holder.modulate.a = fade_out_curve.interpolate(1 - time / duration)
			else:
				set_process(false)
				_on_transition_finished(false)


func transition(new_scene_: Node, old_scene_: Node, duration_: float):
	.transition(new_scene_, old_scene_, duration_)
	set_process(true)
	
	old_scene.visible = true
	new_scene.visible = true
	
	old_scene_original_parent = old_scene.get_parent()
	old_scene_original_parent.remove_child(new_scene_)
	new_scene_original_parent = new_scene_.get_parent()
	new_scene_original_parent.remove_child(old_scene_)
	old_scene_holder.add_child(old_scene_)
	new_scene_holder.add_child(new_scene_)
	time = 0
	state = State.FADE_IN


func _on_transition_finished(skipped):
	._on_transition_finished(skipped)
	old_scene_holder.remove_child(old_scene)
	new_scene_holder.remove_child(new_scene)
	old_scene_original_parent.add_child(old_scene)
	new_scene_original_parent.add_child(new_scene)
	state = State.IDLE
