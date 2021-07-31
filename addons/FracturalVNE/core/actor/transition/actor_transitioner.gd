extends Node
# Controls the transitioning of an Actor


export var actor_path: NodePath
export var actor_holder_path: NodePath

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


func show(transition = null, transition_action = null, duration = 1):
	actor.visible = true
	if transition != null:
		if curr_transition != null:
			story_director.remove_step_action(curr_transition_action)
			curr_transition._on_transition_finished(true)
		curr_transition = transition
		curr_transition_action = transition_action
		
		actor.add_child(transition)
		transition.connect("transition_finished", self, "_on_transition_finished")
		story_director.add_step_action(curr_transition_action)
		transition.show_transition(actor_holder, duration)


func hide(transition = null, transition_action = null, duration = 1):
	if transition != null:
		if curr_transition != null:
			story_director.remove_step_action(curr_transition_action)
			curr_transition._on_transition_finished(true)
		curr_transition = transition
		curr_transition_action = transition_action
		
		actor.add_child(transition)
		transition.connect("transition_finished", self, "_on_transition_finished")
		story_director.add_step_action(curr_transition_action)
		transition.hide_transition(actor_holder, duration)
	else:
		actor.visible = false


# If we are animating the hiding of a actor, we want to only hide the 
# actor once the hiding animation finishes. 
func _on_transition_finished(skipped):
	if not skipped and curr_transition_action != null:
		story_director.remove_step_action(curr_transition_action)
	curr_transition_action = null
	curr_transition.queue_free()
	curr_transition = null
