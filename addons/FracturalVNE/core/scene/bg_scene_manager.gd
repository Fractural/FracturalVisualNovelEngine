extends Node
# Manages the loading and unloading of scenes, which serve as backdrops
# for a story.


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
	FuncDef.new("Scene", [
		Param.new("texture_path"),
		Param.new("cached", false),
		]),
	FuncDef.new("PrefabScene", [
		Param.new("prefab_path"),
		Param.new("cached", false),
		]),
]


func configure_service(program_node):
	for scene in scene_controller_lookup.values():
		scene.queue_free()
	scene_controller_lookup = {}
	scenes = []
	
	current_scene = null
	curr_scene_transition_action = null
	curr_transition = null
	new_scene = null


func get_service_name():
	return "BGSceneManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const ImageScene = preload("res://addons/FracturalVNE/core/scene/types/image_scene/image_scene.gd")
const PrefabScene = preload("res://addons/FracturalVNE/core/scene/types/prefab_scene/prefab_scene.gd")

export var scenes_holder_path: NodePath
export var story_director_path: NodePath
export var resource_loader_path: NodePath
export var reference_registry_path: NodePath
export var serialization_manager_path: NodePath

var scene_controller_lookup: Dictionary = {}
var scenes: Array = []

var current_scene
var curr_scene_transition_action
var curr_transition
var new_scene

onready var scenes_holder = get_node(scenes_holder_path)
onready var story_director = get_node(story_director_path)
onready var resource_loader = get_node(resource_loader_path)
onready var reference_registry = get_node(reference_registry_path)
onready var serialization_manager = get_node(serialization_manager_path)


func add_scene(scene):
	scenes.append(scene)


func remove_scene(scene):
	scenes.erase(scene)
	scene_controller_lookup.erase(scene)


func load_scene_controller(scene):
	var scene_controller = scene.instantiate_controller(story_director)

	if not SSUtils.is_success(scene_controller):
		return SSUtils.stack_error(scene_controller, "Cannot load the scene controller.")

	scene_controller_lookup[scene] = scene_controller
	
	scenes_holder.add_child(scene_controller)
	
	return scene_controller


func remove_scene_controller(scene):
	scene_controller_lookup[scene].queue_free()
	scene_controller_lookup.erase(scene)


# Returns the scene_controller that belongs to the scene. If there is none
# then the a new scene_controller will be loaded, assigned to the scene, 
# and returned.
func get_or_load_scene_controller(scene):
	var scene_controller = scene_controller_lookup.get(scene)
	if scene_controller != null:
		return scene_controller
	return load_scene_controller(scene)


# ----- StoryScriptFunc ----- #

func Scene(texture_path, cached):
	if not texture_path is String:
		return SSUtils.error("Expected textures_directory to be a string.")
	
	var scene = ImageScene.new(texture_path)
	
	var init_result = _init_setup_scene(scene, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return scene


func PrefabScene(prefab_path, cached):
	if not prefab_path is String:
		return SSUtils.error("Expected prefab_path to be a string.")
	
	var scene = PrefabScene.new(prefab_path)
	
	var init_result = _init_setup_scene(scene, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return scene

# ----- StoryScriptFunc ----- #


func show(scene, scenes_holder, transition = null, scene_transition_action = null):
	if curr_scene_transition_action != null:
		story_director.remove_action_step(curr_scene_transition_action)
	curr_scene_transition_action = scene_transition_action
	story_director.add_action_step(curr_scene_transition_action)
	
	new_scene = scene
	curr_transition = transition
	
	scenes_holder.add_child(transition)
	
	if transition != null:
		transition.transition(scene, scenes_holder)
		transition.connect("transition_finished", self, "_on_transition_finished")
	else:
		current_scene.queue_free()
		scenes_holder.add_child(scene)
		_on_transition_finished(false)


func _on_transition_finished(skipped):
	story_director.remove_action_step(curr_scene_transition_action)
	
	current_scene.queue_free()
	current_scene = new_scene
	
	curr_transition.queue_free()
	
	curr_transition = null
	new_scene = null


func _init_setup_scene(scene, cached):
	reference_registry.add_reference(scene)
	add_scene(scene)
	
	# If we are caching the scene controller when we create the scene, then we must
	# load the scene controller immediately (So it will be there for later use).
	if cached:
		var load_result = load_scene_controller(scene)
		if not SSUtils.is_success(load_result):
			return load_result


# ----- Serialization ----- #

func serialize_state():
	var serialized_scene_controller_lookup = {}
	for scene in scene_controller_lookup.keys():
		var scene_id = reference_registry.get_reference_id(scene)
		serialized_scene_controller_lookup[scene_id] = serialization_manager.serialize(scene_controller_lookup[scene])
	
	var scene_ids = []
	for scene in scenes:
		scene_ids.append(reference_registry.get_reference_id(scene))
	
	return {
		"service_name": get_service_name(),
		"scene_controller_lookup": serialized_scene_controller_lookup,
		"scene_ids": scene_ids,
		"current_scene_id": reference_registry.get_reference_id(current_scene),
	}


func deserialize_state(serialized_state):
	for scene in scene_controller_lookup.values():
		scene.queue_free()
	scene_controller_lookup = {}
	scenes = []
	
	for scene_id in serialized_state["scene_controller_lookup"].keys():
		# We have to cast scene_id to an int since serialized dictionaries 
		# cannot store ints??
		var scene_controller = serialization_manager.deserialize(serialized_state["scene_controller_lookup"][scene_id])
		scene_controller_lookup[reference_registry.get_reference(int(scene_id))] = scene_controller
		scenes_holder.add_child(scene_controller)
	
	for scene_id in serialized_state["scene_ids"]:
		scenes.append(reference_registry.get_reference(scene_id))
	
	if serialized_state["current_scene_id"] > -1:
		current_scene = reference_registry.get_reference(serialized_state["current_scene_id"])
# ----- Serialization ----- #
