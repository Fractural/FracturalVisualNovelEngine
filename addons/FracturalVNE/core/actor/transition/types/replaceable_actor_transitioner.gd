extends "res://addons/FracturalVNE/core/actor/transition/actor_transitioner.gd"
# Allows for transitions that replaces the visual of an actor


export var new_node_holder_path: NodePath

onready var new_node_holder = get_node(new_node_holder_path)


func replace(transition = null, transition_action = null, duration = 1):
	if transition != null:
		add_child(transition)
		transition.connect("transition_finished", self, "_on_transition_finished")
		if curr_transition_action != null:
			story_director.remove_step_action(curr_transition_action)
		curr_transition_action = transition_action
		story_director.add_step_action(curr_transition_action)
		transition.replace_transition(new_node_holder, actor_holder, duration)
