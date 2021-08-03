extends Node
# Controls the transitioning of an Actor


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorTransitioner"]

# ----- Typeable ----- #


enum TransitionType {
	NONE,
	SHOW,
	HIDE,
	REPLACE,
}

const TransitionAction = preload("res://addons/FracturalVNE/core/actor/transition/transition_action.gd")

export var actor_path: NodePath
export var actor_holder_path: NodePath
export(TransitionType) var curr_transition_type: int = TransitionType.NONE

var is_hide_animation: bool = false
var curr_transition
var curr_transition_action = null
var story_director

onready var actor = get_node(actor_path)
onready var actor_holder = get_node(actor_holder_path)


# Since transitioners composes actors and cannot exist on its'
# own, we will make it expect a story_director_ by default.
func init(story_director_):
	story_director = story_director_


func show(transition = null, duration = 1):
	_finish_current_transition()
	_set_actor_visibility(true)
	if transition != null:
		_setup_new_transition(TransitionType.SHOW, transition)
		transition.transition(actor_holder, duration)


func hide(transition = null, duration = 1):
	_finish_current_transition()
	if transition != null:
		_setup_new_transition(TransitionType.HIDE, transition)
		transition.transition(actor_holder, duration)
	else:
		_set_actor_visibility(false)


func _set_actor_visibility(value):
	actor.visible = value
	actor_holder.visible = true


func _setup_new_transition(type, transition):
	curr_transition_type = type
	curr_transition = transition
	curr_transition_action = TransitionAction.new(transition)
	actor.add_child(transition)
	transition.connect("transition_finished", self, "_on_transition_finished")
	story_director.add_step_action(curr_transition_action)


func _finish_current_transition():
	if curr_transition != null:
		story_director.remove_step_action(curr_transition_action)
		curr_transition._on_transition_finished(true)


# If we are animating the hiding of a actor, we want to only hide the 
# actor once the hiding animation finishes. 
func _on_transition_finished(skipped):
	# Make visible for replace and show transitions.
	# Make invisible for hide transitions.
	_set_actor_visibility(curr_transition_type != TransitionType.HIDE)
	curr_transition_type = TransitionType.NONE
	if not skipped and curr_transition_action != null:
		story_director.remove_step_action(curr_transition_action)
	curr_transition_action = null
	curr_transition.queue_free()
	curr_transition = null
