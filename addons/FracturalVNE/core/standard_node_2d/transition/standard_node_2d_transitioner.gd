extends Node
# Controls the transitioning of a StandardNode2DTransitioner.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2DTransitioner"]

# ----- Typeable ----- #


signal transition_started(transition_type)
signal transition_finished(transition_type, skipped)

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

var curr_transition
var curr_transition_action = null
var story_director

onready var node_holder = get_node_or_null(node_holder_path)
onready var transition_holder = get_node(transition_holder_path)


# Since transitioners composes nodes and cannot exist on its'
# own, we will make it expect a story_director_ by default.
func init(story_director_) -> void:
	story_director = story_director_


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_destruct()


func _destruct():
	if curr_transition_action != null and story_director != null:
		story_director.remove_step_action(curr_transition_action)


# -- StoryScriptErrorable -- #
func show(transition: FracVNE_StandardNode2DTransition = null, duration: float = 1, is_skippable: bool = true):
	_force_clear_current_transition()
	if curr_transition != null:
		_on_transition_finished(true)
	node_holder.visible = true
	if transition != null:
		var result = _setup_new_transition(TransitionType.SHOW, transition, is_skippable)
		if not SSUtils.is_success(result):
			return result
		result = curr_transition.transition(node_holder, duration)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not play show transition.")
	else:
		_on_transition_finished(false)


# -- StoryScriptErrorable -- #
func hide(transition: FracVNE_StandardNode2DTransition = null, duration: float = 1, is_skippable: bool = true):
	_force_clear_current_transition()
	node_holder.visible = true
	if transition != null:
		var result = _setup_new_transition(TransitionType.HIDE, transition, is_skippable)
		if not SSUtils.is_success(result):
			return result
		result = curr_transition.transition(node_holder, duration)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not play hide transition.")
	else:
		_on_transition_finished(false)


# -- StoryScriptErrorable -- #
func _setup_new_transition(type: int, transition: FracVNE_StandardNode2DTransition, is_skippable: bool):
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
	
	curr_transition_action = TransitionAction.new(curr_transition, is_skippable)
	transition_holder.add_child(curr_transition)
	curr_transition.connect("transition_finished", self, "_on_transition_finished")
	story_director.add_step_action(curr_transition_action)
	
	emit_signal("transition_started", curr_transition_type)


# Called whenever a new transition is played,
# which should override the current playing transition 
# if there is any.
func _force_clear_current_transition() -> void:
	if curr_transition != null:
		# We have to manually remove the transition action
		# since calling _on_transition_finished with skipped=true
		# will assume the action has already been removed by
		# the StoryDirector during skipping.
		story_director.remove_step_action(curr_transition_action)
		
		# _on_transjtion_finished(skipped=true) is invoked
		# on the transition by the TransitionAction. But since we
		# want to emulate a skip, we have to manually
		# call the transition with skipped=true.
		#
		# Note that we do not have to disconnect the self._on_transition_finsihed()
		# function that's connected to curr_transition._on_transition_finished()
		# since we also want self._on_transition_finsihed() to run
		# after the skip. 
		#
		# (Basically the regular call order established by
		# the curr_transition._on_transition_finsihed() is what we want.)
		curr_transition._on_transition_finished(true)


func _on_transition_finished(skipped: bool) -> void:
	# Make visible for replace and show transitions.
	# Make invisible for hide transitions.
	node_holder.visible = curr_transition_type != TransitionType.HIDE
	
	# Save the transition type for emitting
	# once _on_transition_finished() is finished.
	var cache_transition_type = curr_transition_type
	
	curr_transition_type = TransitionType.NONE
	if curr_transition != null:
		# We want to clean up the current transition
		if not skipped:
			# We have finished naturally, therefore we have to
			# manually clean up the step action we added..
			story_director.remove_step_action(curr_transition_action)
		
		# Clean up transiton no matter if the transition
		# was skipped or if it completed naturally.
		curr_transition.queue_free()
		curr_transition = null
	
	emit_signal("transition_finished", cache_transition_type, skipped)
