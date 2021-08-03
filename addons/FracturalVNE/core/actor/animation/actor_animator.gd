extends Node
# Animates an actor


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorAnimator"]

# ----- Typeable ----- #


signal animation_finished(skipped)

const AnimationAction = preload("res://addons/FracturalVNE/core/actor/animation/animation_action.gd")

export var actor_path: NodePath
export var actor_holder_path: NodePath

var curr_actor_animation
var curr_animation_action
var story_director

onready var actor = get_node(actor_path)

# This holder is moved during animations and then the entire actor
# is then repositioned to this holder's position after the animation ends.
# This allows animations to permenantly affect the position of the actor
# and allow future animations to also modify the position of the actor
# since the actor_holder will always be at origin (0,0) before
# each animation is played.
onready var actor_holder = get_node(actor_holder_path)


func init(story_director_):
	story_director = story_director_


func play_animation(actor_animation):
	if curr_animation_action != null:
		story_director.remove_step_action(curr_animation_action)
	curr_animation_action = AnimationAction.new(actor_animation)
	story_director.add_step_action(curr_animation_action)
	
	if curr_actor_animation != null:
		# False triggers the removal of the action
		_on_animation_finished(false)
	
	curr_actor_animation = actor_animation
	curr_actor_animation.connect("animation_finished", self, "_on_animation_finished")
	
	actor.add_child(curr_actor_animation)
	curr_actor_animation.animate(actor_holder)


func _on_animation_finished(skipped):
	if not skipped and curr_animation_action != null:
		story_director.remove_step_action(curr_animation_action)
	curr_animation_action = null
	
	# Move the actor to the actor_holder's position to
	# reset the actor_holder's position to (0, 0) which allows 
	# a future animation to play starting from (0, 0).
	actor.global_position = actor_holder.global_position
	actor_holder.position = Vector2.ZERO
	
	curr_actor_animation.queue_free()
	curr_actor_animation = null
	
	emit_signal("animation_finished", skipped)
