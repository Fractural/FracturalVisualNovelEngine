extends "res://addons/FracturalVNE/core/scene/scene_transition.gd"
# Scene transition that fades the backgroudn into and out of a solid color


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("FadeToColorSceneTransition")
	return arr

# ----- Typeable ----- #


enum State {
	IDLE,
	FADE_IN,
	FADE_OUT
}

export var solid_color_node_path: NodePath
export var scene_holder_path: NodePath
export var fade_in_curve: Curve
export var fade_out_curve: Curve

var time: float
var state: int
var old_scene_original_parent: Node
var new_scene_original_parent: Node

onready var solid_color_node: Node2D = get_node(solid_color_node_path)
onready var scene_holder = get_node(scene_holder_path)


func _process(delta):
	match state:
		State.FADE_IN:
			if time < duration / 2:
				time += delta
				solid_color_node.modulate.a = fade_in_curve.interpolate(time / duration)
			else:
				old_scene.visible = false
				new_scene.visible = true
				state = State.FADE_OUT
				time = 0
		State.FADE_OUT:
			if time < duration / 2:
				time += delta
				solid_color_node.modulate.a = fade_out_curve.interpolate(1 - time / duration)
			else:
				set_process(false)
				_on_transition_finished(false)


func transition(new_scene_: Node, old_scene_: Node, duration_: float):
	.transition(new_scene_, old_scene_, duration_)
	set_process(true)
	
	old_scene.visible = true
	new_scene.visible = false
	
	old_scene_original_parent = old_scene.get_parent()
	old_scene_original_parent.remove_child(new_scene_)
	new_scene_original_parent = new_scene_.get_parent()
	new_scene_original_parent.remove_child(old_scene_)
	scene_holder.add_child(old_scene_)
	scene_holder.add_child(new_scene_)
	time = 0
	state = State.FADE_IN


func _on_transition_finished(skipped):
	._on_transition_finished(skipped)
	scene_holder.remove_child(old_scene)
	scene_holder.remove_child(new_scene)
	old_scene_original_parent.add_child(old_scene)
	new_scene_original_parent.add_child(new_scene)
	state = State.IDLE
