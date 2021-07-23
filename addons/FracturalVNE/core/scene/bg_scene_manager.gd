extends Node
# Manages the loading and unloading of scenes, which serve as backdrops
# for a story.


# ----- StoryService ----- #

func configure_service(program_node):
	if current_scene != null:
		current_scene.queue_free()
	current_scene = null


func get_service_name():
	return "BGSceneManager"

# ----- StoryService ----- #


export var scene_holder_path: NodePath
export var story_director_path: NodePath

var current_scene
var curr_scene_transition_action
var curr_transition
var new_scene

onready var scene_holder = get_node(scene_holder_path)
onready var story_director = get_node(story_director_path)


func show(scene, scene_holder, transition = null, scene_transition_action = null):
	if curr_scene_transition_action != null:
		story_director.remove_action_step(curr_scene_transition_action)
	curr_scene_transition_action = scene_transition_action
	story_director.add_action_step(curr_scene_transition_action)
	
	new_scene = scene
	curr_transition = transition
	
	scene_holder.add_child(transition)
	
	if transition != null:
		transition.transition(scene, scene_holder)
		transition.connect("transition_finished", self, "_on_transition_finished")
	else:
		current_scene.queue_free()
		scene_holder.add_child(scene)
		_on_transition_finished(false)


func _on_transition_finished(skipped):
	story_director.remove_action_step(curr_scene_transition_action)
	
	current_scene.queue_free()
	current_scene = new_scene
	
	curr_transition.queue_free()
	
	curr_transition = null
	new_scene = null
