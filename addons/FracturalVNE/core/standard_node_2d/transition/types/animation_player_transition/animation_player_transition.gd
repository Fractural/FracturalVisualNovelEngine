extends "res://addons/FracturalVNE/core/standard_node_2d/transition/sub_transitions/single_transition/single_transition.gd"
# Shows a node with a curve


const Utils = preload("res://addons/FracturalVNE/core/utils/utils.gd")

export var animation_player_path: NodePath
export var node_holder_path: NodePath
export var play_animation_backwards: bool = false
export var animation: Animation

var time
var original_node_parent: Node

onready var animation_player: AnimationPlayer = get_node(animation_player_path)
onready var node_holder = get_node(node_holder_path)


func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_animation_finished")
	animation_player.root_node = node_holder_path
	animation_player.add_animation("Animation", animation)


func transition(node_: Node, duration_: float):
	if not .transition(node_, duration_):
		return false
	
	original_node_parent = node.get_parent()
	Utils.reparent(node, node_holder)
	
	if play_animation_backwards:
		animation_player.play_backwards("Animation")
	else:
		animation_player.play("Animation")
	
	set_process(true)
	return true


func _on_animation_finished(animation_name: String) -> void:
	# This will not get called if we animation_player.seek() to the end of
	# the animation so we don't have to worry about possibly double calling 
	# _on_transition_finished()
	_on_transition_finished(false)


func _on_transition_finished(skipped: bool) -> void:
	if skipped:
		if play_animation_backwards:
			animation_player.seek(0, true)
		else:
			animation_player.seek(animation_player.current_animation_length, true)
	
	Utils.reparent(node, original_node_parent)
	
	._on_transition_finished(skipped)
