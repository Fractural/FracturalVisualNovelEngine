extends Node
# Creates and keeps track of Visuals.


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
		FuncDef.new("Visual", [
			Param.new("texture_path"),
			Param.new("cached", false),
		]),
		FuncDef.new("DynamicVisual", [
			Param.new("textures_directory"),
			Param.new("cached", false),
		]),
		FuncDef.new("PrefabVisual", [
			Param.new("prefab_path"),
			Param.new("cached", false),
		]),
	]


func get_service_name():
	return "VisualManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const SingleVisual = preload("types/single_visual/single_visual.gd")
const MultiVisual = preload("types/multi_visual/multi_visual.gd")
const PrefabVisual = preload("types/prefab_visual/prefab_visual.gd")

export var actor_manager_path: NodePath 

onready var actor_manager = get_node(actor_manager_path)


func add_visual(visual):
	assert(FracVNE.Utils.is_type(visual, "Visual"))
	actor_manager.add_actor(visual)


func remove_visual(visual):
	assert(FracVNE.Utils.is_type(visual, "Visual"))
	actor_manager.remove_actor(visual)


func load_visual_controller(visual):
	assert(FracVNE.Utils.is_type(visual, "Visual"))
	actor_manager.load_actor_controller(visual)


func remove_visual_controller(visual):
	assert(FracVNE.Utils.is_type(visual, "Visual"))
	actor_manager.remove_actor_controller(visual)


# Returns the visual_controller that belongs to the visual. If there is none
# then the a new visual_controller will be loaded, assigned to the visual, 
# and returned.
func get_or_load_visual_controller(visual):
	assert(FracVNE.Utils.is_type(visual, "Visual"))
	return actor_manager.get_or_load_actor_controller(visual)


# ----- StoryScriptFunc ----- #

func DynamicVisual(textures_directory, cached):
	if not textures_directory is String:
		return SSUtils.error("Expected textures_directory to be a string.")
	
	var visual = MultiVisual.new(cached, textures_directory)

	var init_result = actor_manager.add_new_actor(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual


func Visual(texture_path, cached):
	if not texture_path is String:
		return SSUtils.error("Expected texture_path to be a string.")
	
	var visual = SingleVisual.new(cached, texture_path)
	
	var init_result = actor_manager.add_new_actor(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual


func PrefabVisual(prefab_path, cached):
	if not prefab_path is String:
		return SSUtils.error("Expected prefab_path to be a string.")
	
	var visual = PrefabVisual.new(cached, prefab_path)
	
	var init_result = actor_manager.add_new_actor(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual

# ----- StoryScriptFunc ----- #
