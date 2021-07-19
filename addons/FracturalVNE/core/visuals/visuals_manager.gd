extends Node
# Handles showing, hiding, and animating? visuals

# TODO: Maybe separate animating (moving sprites around) into another manager?
# 		Is animating the visual manager's responsibility?


# ----- StoryService ----- #

var function_definitions = [
		StoryScriptFuncDef.new("Visual", [
			StoryScriptParameter.new("texture_path"),
		]),
		StoryScriptFuncDef.new("DynamicVisual", [
			StoryScriptParameter.new("textures_directory"),
		]),
		StoryScriptFuncDef.new("PrefabVisual", [
			StoryScriptParameter.new("prefab_path"),
		]),
		StoryScriptFuncDef.new("show_multi_visual", [
			StoryScriptParameter.new("visual"),
			StoryScriptParameter.new("modifiers"),
			StoryScriptParameter.new("animation"),
		]),
		StoryScriptFuncDef.new("show_visual", [
			StoryScriptParameter.new("visual"),
			StoryScriptParameter.new("animation"),
		]),
		StoryScriptFuncDef.new("hide_visual", [
			StoryScriptParameter.new("visual"),
			StoryScriptParameter.new("animation"),
		]),
	]


func get_service_name():
	return "VisualsManager"

# ----- StoryService ----- #


const single_visual_prefab = preload("single_visual.tscn")
const dynamic_visual_prefab = preload("multi_visual.tscn")
const prefab_visual_prefab = preload("prefab_visual.tscn")

export var reference_registry_path: NodePath
export var visuals_holder_path: NodePath
export var story_director_path: NodePath

var visuals: Array = []

onready var reference_registry = get_node(reference_registry_path)
onready var visuals_holder = get_node(visuals_holder_path)
onready var story_director = get_node(story_director_path)


func add_visual(visual):
	visuals.append(visual)
	
	visuals_holder.add_child(visual)


func DynamicVisual(textures_directory):
	if typeof(textures_directory) != TYPE_STRING:
		return StoryScriptError.new("Expected textures_directory to be a string.")
	
	var new_visual = dynamic_visual_prefab.instance()
	
	var image_paths = FracturalUtils.get_dir_contents(textures_directory, true, ["png", "jpeg", "jpg", "bmp"])[0]
	var textures = []
	
	for path in image_paths:
		textures.append(load(path))
	
	new_visual.init_(story_director, textures)
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	return new_visual


func Visual(texture_path):
	if typeof(texture_path) != TYPE_STRING:
		return StoryScriptError.new("Expected texture_path to be a string.")
	
	var new_visual = single_visual_prefab.instance()
	
	# TODO: Replacing load() with ResourceLoader in order to handle
	# 		cases where the resource could not be loaded. When this
	#		happens, return a StoryScriptError.
	new_visual.init_(story_director, load(texture_path))
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	return new_visual


func PrefabVisual(prefab_path):
	if typeof(prefab_path) != TYPE_STRING:
		return StoryScriptError.new("Expected prefab_path to be a string.")
	
	var new_visual = prefab_visual_prefab.instance()
	
	new_visual.init_(story_director, prefab_path)
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	return new_visual


func show_multi_visual(target_visual, modifiers_string = null, animation = null):
	if modifiers_string != null and typeof(modifiers_string) == TYPE_STRING:
		visuals[target_visual].set_sprite(target_visual.get_texture(modifiers_string))
	return show_visual(target_visual, animation)


func show_visual(target_visual, animation = null):
	if typeof(target_visual) == TYPE_OBJECT and target_visual.is_type("Visual"):
		if not visuals.has(target_visual):
			# The target_visual has not been registered yet, so we register it 
			push_warning("FracVNE: target_visual has not been registered with VisualsManager.")
			add_visual(target_visual)
		target_visual.show(animation)
	else:
		return StoryScriptError.new("Expected target_visual to be a string or a Visual.")


func hide_visual(target_visual, animation = null):
	if typeof(target_visual) == TYPE_OBJECT and target_visual.is_type("Visual"):
		if not visuals.has(target_visual):
			# The target_visual has not been registered yet, so we register it 
			push_warning("FracVNE: target_visual has not been registered with VisualsManager.")
			add_visual(target_visual)
		target_visual.hide(animation)
	else:
		return StoryScriptError.new("Expected target_visual to be a string or a Visual.")


# TODO: Maybe remove if we are using "show" to both animate and show a Visual
func animate_visual(target_visual, animation):
	target_visual.visual_animator.play_animation(animation)


# ----- Serialization ----- #

func serialize_state():
	var visual_ids = []
	
	for visual in visuals:
		visual_ids.append(reference_registry.get_reference_id(visual))
	
	return {
		"service_name": get_service_name(),
		"visual_ids": visual_ids,
	}


func deserialize_state(serialized_state):
	for visual in visuals:
		visual.queue_free()
	
	visuals = []
	
	for visual_id in serialized_state["visual_ids"]:
		add_visual(reference_registry.get_reference(visual_id))

# ----- Serialization ----- #
