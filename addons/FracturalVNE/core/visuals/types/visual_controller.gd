extends Node2D
# Base class for all VisualControllers.


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)


static func get_types() -> Array:
	return ["VisualController"]

# ----- Typeable ----- #


export var visual_animator_path: NodePath
export var visual_mover_path: NodePath
export var visual_holder_path: NodePath
export var story_director_dep_path: NodePath

var visual
var is_hide_animation: bool = false
var curr_transition_action = null

onready var visual_animator = get_node(visual_animator_path)
onready var visual_mover = get_node(visual_mover_path)
onready var visual_holder = get_node(visual_holder_path)
onready var story_director_dep = get_node(story_director_dep_path)


func init(visual_, story_director):
	story_director_dep = get_node(story_director_dep_path)
	story_director_dep.dependency_path = story_director.get_path()
	
	visual = visual_
	
	visual_animator = get_node(visual_animator_path)
	visual_mover = get_node(visual_mover_path)
	
	visual_animator.init(story_director)
	visual_mover.init(story_director)


func show(transition = null, transition_action = null):
	visible = true
	if transition != null:
		add_child(transition)
		transition.connect("transition_finished", self, "_on_transition_finished")
		if curr_transition_action != null:
			story_director_dep.dependency.remove_step_action(curr_transition_action)
		curr_transition_action = transition_action
		story_director_dep.dependency.add_step_action(curr_transition_action)
		# TEMP HACK: Transition with duraiton of 1. Replace with actual duration parsing
		#			 If this implementation of transitions is performant enough
		transition.show_transition(visual_holder, 1)


func hide(transition = null, transition_action = null):
	if transition != null:
		add_child(transition)
		transition.connect("transition_finished", self, "_on_transition_finished")
		if curr_transition_action != null:
			story_director_dep.dependency.remove_step_action(curr_transition_action)
		curr_transition_action = transition_action
		story_director_dep.dependency.add_step_action(curr_transition_action)
		transition.hide_transition(visual_holder, 1)
	else:
		visible = false


# If we are animating the hiding of a visual, we want to only hide the 
# visual once the hiding animation finishes. 
func _on_transition_finished(skipped):
	if not skipped and curr_transition_action != null:
		story_director_dep.dependency.remove_step_action(curr_transition_action)
