extends Node
# Handles showing, hiding, and animating? visuals

# TODO: Maybe separate animating (moving sprites around) into another manager?
# 		Is animating the visual manager's responsibility?


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


func configure_service(program_node):
	for visual in visual_controller_lookup.values():
		visual.queue_free()
	visual_controller_lookup = {}
	visuals = []


func get_service_name():
	return "VisualManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils
const SingleVisual = preload("types/single_visual/single_visual.gd")
const MultiVisual = preload("types/multi_visual/multi_visual.gd")
const PrefabVisual = preload("types/prefab_visual/prefab_visual.gd")

export var reference_registry_path: NodePath
export var visuals_holder_path: NodePath
export var story_director_path: NodePath
export var serialization_manager_path: NodePath


# The active visual that is associated with this visual if any.
# Each visual can have one unique active visual associated with it.
# The VisualBlueprint + Visual pairs are stored in this dictionary.
#
# Keys: VisualBlueprint
# Values: Visual
var visual_controller_lookup: Dictionary = {}
var visuals: Array = []

onready var reference_registry = get_node(reference_registry_path)
onready var visuals_holder = get_node(visuals_holder_path)
onready var story_director = get_node(story_director_path)
onready var serialization_manager = get_node(serialization_manager_path)


func add_visual(visual):
	visuals.append(visual)


func remove_visual(visual):
	visuals.erase(visual)
	visual_controller_lookup.erase(visual)


func load_visual_controller(visual):
	var visual_controller = visual.instantiate_controller(story_director)

	if not SSUtils.is_success(visual_controller):
		return SSUtils.stack_error(visual_controller, "Cannot load the visual controller.")

	visual_controller_lookup[visual] = visual_controller
	
	visuals_holder.add_child(visual_controller)
	
	return visual_controller


func remove_visual_controller(visual):
	visual_controller_lookup[visual].queue_free()
	visual_controller_lookup.erase(visual)


# Returns the visual_controller that belongs to the visual. If there is none
# then the a new visual_controller will be loaded, assigned to the visual, 
# and returned.
func get_or_load_visual_controller(visual):
	var visual_controller = visual_controller_lookup.get(visual)
	if visual_controller != null:
		return visual_controller
	return load_visual_controller(visual)


# ----- StoryScriptFunc ----- #

func DynamicVisual(textures_directory, cached):
	if not textures_directory is String:
		return SSUtils.error("Expected textures_directory to be a string.")
	
	var visual = MultiVisual.new(cached, textures_directory)

	var init_result = _init_setup_visual(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual


func Visual(texture_path, cached):
	if not texture_path is String:
		return SSUtils.error("Expected texture_path to be a string.")
	
	var visual = SingleVisual.new(cached, texture_path)
	
	var init_result = _init_setup_visual(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual


func PrefabVisual(prefab_path, cached):
	if not prefab_path is String:
		return SSUtils.error("Expected prefab_path to be a string.")
	
	var visual = PrefabVisual.new(cached, prefab_path)
	
	var init_result = _init_setup_visual(visual, cached)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return visual

# ----- StoryScriptFunc ----- #


func _init_setup_visual(visual, cached):
	reference_registry.add_reference(visual)
	add_visual(visual)
	
	# If we are caching the visual controller when we create the visual, then we must
	# load the visual controller immediately (So it will be there for later use).
	if cached:
		var load_result = load_visual_controller(visual)
		if not SSUtils.is_success(load_result):
			return load_result


# ----- Serialization ----- #

func serialize_state():
	var serialized_visual_controller_lookup = {}
	for visual in visual_controller_lookup.keys():
		var visual_id = reference_registry.get_reference_id(visual)
		serialized_visual_controller_lookup[visual_id] = serialization_manager.serialize(visual_controller_lookup[visual])
	
	var visual_ids = []
	for visual in visuals:
		visual_ids.append(reference_registry.get_reference_id(visual))
	
	return {
		"service_name": get_service_name(),
		"visual_controller_lookup": serialized_visual_controller_lookup,
		"visual_ids": visual_ids,
	}


func deserialize_state(serialized_state):
	for visual in visual_controller_lookup.values():
		visual.queue_free()
	visual_controller_lookup = {}
	visuals = []
	
	for visual_id in serialized_state["visual_controller_lookup"].keys():
		# We have to cast visual_id to an int since serialized dictionaries 
		# cannot store ints??
		var visual_controller = serialization_manager.deserialize(serialized_state["visual_controller_lookup"][visual_id])
		visual_controller_lookup[reference_registry.get_reference(int(visual_id))] = visual_controller
		visuals_holder.add_child(visual_controller)
	
	for visual_id in serialized_state["visual_ids"]:
		visuals.append(reference_registry.get_reference(visual_id))

# ----- Serialization ----- #
