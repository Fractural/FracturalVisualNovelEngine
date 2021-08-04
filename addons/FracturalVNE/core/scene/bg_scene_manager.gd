extends Node
# Manages the loading and unloading of scenes, which serve as backdrops
# for a story.

# TODO: Finish BGSceneManager


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
	current_scene = null
	_old_scene = null


func get_service_name():
	return "BGSceneManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const ImageScene = preload("res://addons/FracturalVNE/core/scene/types/image_scene/image_scene.gd")
const PrefabScene = preload("res://addons/FracturalVNE/core/scene/types/prefab_scene/prefab_scene.gd")

export var actor_manager_path: NodePath
export var scenes_holder_path: NodePath
export var replaceable_transitioner_path: NodePath
export var reference_registry_path: NodePath
export var current_scene_holder_path: NodePath
export var old_scene_holder_path: NodePath

var current_scene
var _old_scene
var _keep_old_scene: bool

onready var actor_manager = get_node(actor_manager_path)
onready var scenes_holder = get_node(scenes_holder_path)
onready var replaceable_transitioner = get_node(replaceable_transitioner_path)
onready var reference_registry = get_node(reference_registry_path)
onready var current_scene_holder = get_node(current_scene_holder_path)
onready var old_scene_holder = get_node(old_scene_holder_path)


func _ready():
	replaceable_transitioner.connect("transition_finished", self, "_on_transition_finished")


# ----- Generic Actor Manager Funcs ----- #

func add_scene(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.add_actor(scene)


func remove_scene(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.remove_actor(scene)


func load_scene_controller(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.load_actor_controller(scene)


func remove_scene_controller(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.remove_actor_controller(scene)


func get_or_load_scene_controller(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.get_or_load_actor_controller(scene)


func get_scene_controller(scene):
	assert(FracVNE.Utils.is_type(scene, "BGScene"))
	actor_manager.get_actor_controller(scene)


func add_new_scene_with_controller(scene, scene_controller):
	assert(FracVNE.Utils.is_type(scene, "BGScene")
		and FracVNE.Utils.is_type(scene_controller, "BGSceneController"))
	actor_manager.add_new_actor_with_controller(scene, scene_controller)

# ----- Generic Actor Manager Funcs ----- #


# ----- StoryScriptFunc ----- #

func Scene(texture_path, cached):
	if not texture_path is String:
		return SSUtils.error("Expected textures_directory to be a string.")
	
	
	var texture = SSUtils.load(texture_path)
	if not SSUtils.is_success(texture):
		return texture
	
	var scene = ImageScene.new(texture)
	
	var init_result = actor_manager.add_new_actor(scene, cached, scenes_holder)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return scene


func PrefabScene(prefab_path, cached):
	if not prefab_path is String:
		return SSUtils.error("Expected prefab_path to be a string.")
	
	var prefab = SSUtils.load(prefab_path)
	if not SSUtils.is_success(prefab):
		return prefab
	
	var scene = PrefabScene.new(prefab)
	
	var init_result = actor_manager.add_new_actor(scene, cached, scenes_holder)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return scene

# ----- StoryScriptFunc ----- #


# TODO: Write start trans
# 		Maybe make a custom screenshot taker that only
#		gets a texture of the current game scene?
#		Also hide the UI when transitioning.
func start_transition(scene, transition):
	pass


func end_transition():
	pass


func show_scene(scene, transition = null, keep_old_scene = false):
	# Note that there is currently no support for hiding a background.
	# (You are expected to have a background).
	_old_scene = current_scene
	_keep_old_scene = keep_old_scene
	
	current_scene = scene
	
	var old_scene_controller = get_or_load_scene_controller(_old_scene)
	var current_scene_controller = get_scene_controller(current_scene)
	
	FracVNE.Utils.reparent(current_scene, current_scene_holder)
	FracVNE.Utils.reparent(_old_scene, old_scene_holder)
	
	if old_scene_controller != null and current_scene_controller != null:
		replaceable_transitioner.replace(transition)
	elif current_scene_controller != null:
		replaceable_transitioner.show(transition)


func _on_transition_finished(skipped):
	if not _keep_old_scene:
		remove_scene_controller(_old_scene)
	else:
		# Reparent the unused scene back to the scenes holder
		FracVNE.Utils.reparent(get_scene_controller(_old_scene), scenes_holder)
	
	# No need to reparent the current scene since it's already attached
	# to the current_scene_holder
	_old_scene = null


# ----- Serialization ----- #

func serialize_state():
	return {
		"service_name": get_service_name(),
		"current_scene_id": reference_registry.get_reference_id(current_scene),
	}


func deserialize_state(serialized_state):
	if serialized_state["current_scene_id"] > -1:
		current_scene = reference_registry.get_reference(serialized_state["current_scene_id"])

# ----- Serialization ----- #
