extends Node
# Manages the loading and unloading of scenes, which serve as backdrops
# for a story.


# ----- StoryService ----- #

var function_definitions = [
	FracVNE.StoryScript.FuncDef.new("Scene", [
		FracVNE.StoryScript.Param.new("texture_path"),
		]),
	FracVNE.StoryScript.FuncDef.new("PrefabScene", [
		FracVNE.StoryScript.Param.new("scene_path"),
		]),
]


func configure_service(program_node):
	if current_scene != null:
		current_scene.queue_free()
	current_scene = null


func get_service_name():
	return "BGSceneManager"

# ----- StoryService ----- #


export var scene_holder_path: NodePath
export var story_director_path: NodePath
export var resource_loader_path: NodePath

var current_scene
var curr_scene_transition_action
var curr_transition
var new_scene

onready var scene_holder = get_node(scene_holder_path)
onready var story_director = get_node(story_director_path)
onready var resource_loader = get_node(resource_loader_path)


func Scene(texture_path):
	var texture_result = resource_loader.load(texture_path)
	if FracVNE.StoryScript.Utils.is_success(resource_loader):
		return FracVNE.StoryScript.Error.new("Could not load")
		# TODO NOW: Finish Scene and PrefabScene
		#			Allow Scenes and Visuals to override caching
		#			Create dedicated StoryService called "CacheManager" (Maybe merge with resource loader?), which is in charge of
		#			handling caching images etc. This will have the option to load a resource with or without caching.
		#			Note that in order for this to work, ALL REFERENCES of the resource must be removed. Using Visuals as an
		#			example, the texture on the sprite must be set to null even if the Visual is invisible.

func PrefabScene(scene_path):
	pass


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
