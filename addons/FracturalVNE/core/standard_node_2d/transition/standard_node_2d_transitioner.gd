extends Node
# Controls the transitioning of a StandardNode2DTransitioner.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2DTransitioner"]

# ----- Typeable ----- #


signal transition_finished(skipped)

enum TransitionType {
	NONE,
	SHOW,
	HIDE,
	REPLACE,
}

const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils
const TransitionAction = preload("res://addons/FracturalVNE/core/standard_node_2d/transition/transition_action.gd")

export var node_holder_path: NodePath
export var transition_holder_path: NodePath
export(TransitionType) var curr_transition_type: int = TransitionType.NONE

var is_hide_animation: bool = false
var curr_transition
var curr_transition_action = null
var story_director

onready var node_holder = get_node(node_holder_path)
onready var transition_holder = get_node(transition_holder_path)

# Since transitioners composes nodes and cannot exist on its'
# own, we will make it expect a story_director_ by default.
func init(story_director_):
	story_director = story_director_


func show(transition = null, duration = 1):
	_finish_current_transition()
	node_holder.visible = true
	if transition != null:
		var result = _setup_new_transition(TransitionType.SHOW, transition)
		if not SSUtils.is_success(result):
			return result
		result = curr_transition.transition(node_holder, duration)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not play show transition.")
	else:
		_on_transition_finished(false)


func hide(transition = null, duration = 1):
	_finish_current_transition()
	node_holder.visible = true
	if transition != null:
		var result = _setup_new_transition(TransitionType.HIDE, transition)
		if not SSUtils.is_success(result):
			return result
		result = curr_transition.transition(node_holder, duration)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not play hide transition.")
	else:
		_on_transition_finished(false)


func _setup_new_transition(type, transition):
	curr_transition_type = type
	
	# Assign current transition
	if FracUtils.is_type(transition, "StandardNode2DTransition"):
		match curr_transition_type:
			TransitionType.SHOW:
				if transition.show_transition == null:
					return SSUtils.error("Expected a show transition but got null instead.")
				curr_transition = transition.show_transition.instance()
			TransitionType.HIDE:
				if transition.hide_transition == null:
					return SSUtils.error("Expected a hide transition but got null instead.")
				curr_transition = transition.hide_transition.instance()
			TransitionType.REPLACE:
				if transition.replace_transition == null:
					return SSUtils.error("Expected a replace transition but got null instead.")
				curr_transition = transition.replace_transition.instance()
	else:
		curr_transition = transition
	
	# Type safety check
	match curr_transition_type:
		TransitionType.SHOW:
			if not FracUtils.is_type(curr_transition, "SingleTransition"):
				return SSUtils.error("Expected a SingleTransition for a show transition.")
		TransitionType.HIDE:
			if not FracUtils.is_type(curr_transition, "SingleTransition"):
				return SSUtils.error("Expected a SingleTransition for a hide transition.")
		TransitionType.REPLACE:
			if not FracUtils.is_type(curr_transition, "ReplaceTransition"):
				return SSUtils.error("Expected a ReplaceTransition for a show transition.")
	
	curr_transition_action = TransitionAction.new(curr_transition)
	transition_holder.add_child(curr_transition)
	curr_transition.connect("transition_finished", self, "_on_transition_finished")
	story_director.add_step_action(curr_transition_action)
	# TODO NOW: Find out why you cannot skip hide transitions.


func _finish_current_transition():
	if curr_transition != null:
		story_director.remove_step_action(curr_transition_action)
		curr_transition._on_transition_finished(true)


# If we are animating the hiding of a node, we want to only hide the 
# node once the hiding animation finishes. 
func _on_transition_finished(skipped):
	# Make visible for replace and show transitions.
	# Make invisible for hide transitions.
	node_holder.visible = curr_transition_type != TransitionType.HIDE
	curr_transition_type = TransitionType.NONE
	if not skipped and curr_transition_action != null:
		story_director.remove_step_action(curr_transition_action)
	curr_transition_action = null
	curr_transition.queue_free()
	curr_transition = null
	
	emit_signal("transition_finished", skipped)
