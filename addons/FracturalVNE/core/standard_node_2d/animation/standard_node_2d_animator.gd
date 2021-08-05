extends Node
# Animates a StandardNode2D.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2DAnimator"]

# ----- Typeable ----- #


signal animation_finished(skipped)

const AnimationAction = preload("res://addons/FracturalVNE/core/standard_node_2d/animation/animation_action.gd")

export var node_holder_path: NodePath
export var animation_holder_path: NodePath
export var align_parent_position_on_finish: bool = true

var curr_node_animation
var curr_animation_action
var story_director

# This holder is moved during animations and then the entire node
# is then repositioned to this holder's position after the animation ends.
# This allows animations to permenantly affect the position of the node
# and allow future animations to also modify the position of the node
# since the node_holder will always be at origin (0,0) before
# each animation is played.
onready var node_holder = get_node(node_holder_path)
onready var animation_holder = get_node(animation_holder_path)

onready var node_holder_parent = node_holder.get_parent()


func init(story_director_):
	story_director = story_director_


func play_animation(node_animation):
	if curr_animation_action != null:
		story_director.remove_step_action(curr_animation_action)
	curr_animation_action = AnimationAction.new(node_animation)
	story_director.add_step_action(curr_animation_action)
	
	if curr_node_animation != null:
		# False triggers the removal of the action
		_on_animation_finished(false)
	
	curr_node_animation = node_animation
	curr_node_animation.connect("animation_finished", self, "_on_animation_finished")
	
	node_holder_parent.add_child(curr_node_animation)
	curr_node_animation.animate(node_holder)


func _on_animation_finished(skipped: bool):
	if not skipped and curr_animation_action != null:
		story_director.remove_step_action(curr_animation_action)
	curr_animation_action = null
	
	# Move the node to the node_holder's position to
	# reset the node_holder's position to (0, 0) which allows 
	# a future animation to play starting from (0, 0).
	if align_parent_position_on_finish:
		node_holder_parent.global_standard_position = node_holder.global_standard_position
		node_holder_parent.global_standard_rotation = node_holder.global_standard_rotation
		node_holder_parent.global_standard_scale = node_holder.global_standard_scale
		node_holder.standard_position = Vector2.ZERO
		node_holder.standard_rotation = 0
		node_holder.standard_scale = Vector2.ONE
	
	curr_node_animation.queue_free()
	curr_node_animation = null
	
	emit_signal("animation_finished", skipped)
