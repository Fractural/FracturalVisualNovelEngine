extends Node
# Handles showing, hiding, and animating? visuals

# TODO: Maybe separate animating (moving sprites around) into another manager?
# 		Is animating the visual manager's responsibility?


# ----- StoryService ----- #

var function_definitions = [
		FracVNE.StoryScript.FuncDef.new("Visual", [
			FracVNE.StoryScript.Param.new("texture_path"),
		]),
		FracVNE.StoryScript.FuncDef.new("DynamicVisual", [
			FracVNE.StoryScript.Param.new("textures_directory"),
		]),
		FracVNE.StoryScript.FuncDef.new("PrefabVisual", [
			FracVNE.StoryScript.Param.new("prefab_path"),
		]),
		FracVNE.StoryScript.FuncDef.new("show_multi_visual", [
			FracVNE.StoryScript.Param.new("visual"),
			FracVNE.StoryScript.Param.new("modifiers"),
			FracVNE.StoryScript.Param.new("animation"),
		]),
		FracVNE.StoryScript.FuncDef.new("show_visual", [
			FracVNE.StoryScript.Param.new("visual"),
			FracVNE.StoryScript.Param.new("animation"),
		]),
		FracVNE.StoryScript.FuncDef.new("hide_visual", [
			FracVNE.StoryScript.Param.new("visual"),
			FracVNE.StoryScript.Param.new("animation"),
		]),
	]


func configure_service(program_node):
	for visual in visuals:
		visual.queue_free()
	visuals = []


func get_service_name():
	return "VisualsManager"

# ----- StoryService ----- #


const single_visual_prefab = preload("types/single_visual/single_visual.tscn")
const dynamic_visual_prefab = preload("types/multi_visual/multi_visual.tscn")
const prefab_visual_prefab = preload("types/prefab_visual/prefab_visual.tscn")

export var reference_registry_path: NodePath
export var visuals_holder_path: NodePath
export var story_director_path: NodePath

var visuals: Array = []

onready var reference_registry = get_node(reference_registry_path)
onready var visuals_holder = get_node(visuals_holder_path)
onready var story_director = get_node(story_director_path)


func add_visual(visual):
	visuals.append(visual)
	
	var global_pos = visual.position
	visuals_holder.add_child(visual)
	visual.global_position = global_pos


func DynamicVisual(textures_directory):
	if typeof(textures_directory) != TYPE_STRING:
		return FracVNE.StoryScript.Error.new("Expected textures_directory to be a string.")
	
	var new_visual = dynamic_visual_prefab.instance()
	
	var image_paths = FracVNE.StoryScript.Utils.get_dir_contents(textures_directory, true, ["png", "jpeg", "jpg", "bmp"])
	
	if not FracVNE.StoryScript.Utils.is_success(image_paths):
		return FracVNE.StoryScript.Error.ErrorStack.new([image_paths, FracVNE.StoryScript.Error.new("Could not load the texture directory of \"%s\"." % textures_directory)])
	# get_dir_contents() returns an arr formatted as: 
	# [files, directories]
	# We only want the files (Which are images), so we use the 0 index.
	image_paths = image_paths[0]
	
	var textures = []
	
	for path in image_paths:
		textures.append(load(path))
	
	new_visual.init_(story_director, textures)
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	# Visuals should hide by default when first created.
	new_visual.hide()
	
	return new_visual


func Visual(texture_path):
	if typeof(texture_path) != TYPE_STRING:
		return FracVNE.StoryScript.Error.new("Expected texture_path to be a string.")
	
	var new_visual = single_visual_prefab.instance()
	
	var texture_result = ResourceLoader.load(texture_path)
	if texture_result == null:
		return FracVNE.StoryScript.Error.new("Could not load the texture at path \"%s\"" % texture_path)
	
	new_visual.init_(story_director, texture_result)
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	new_visual.hide()
	
	return new_visual


func PrefabVisual(prefab_path):
	if typeof(prefab_path) != TYPE_STRING:
		return FracVNE.StoryScript.Error.new("Expected prefab_path to be a string.")
	
	var visual_prefab_result = ResourceLoader.load(prefab_path)
	if visual_prefab_result == null:
		return FracVNE.StoryScript.Error.new("Could not load the visual prefab at path \"%s\"" % visual_prefab_result)
	
	var new_visual = prefab_visual_prefab.instance()
	new_visual.init_(story_director, visual_prefab_result.instance())
	
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)
	
	new_visual.hide()
	
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
		return FracVNE.StoryScript.Error.new("Expected target_visual to be a string or a Visual.")


func hide_visual(target_visual, animation = null):
	if typeof(target_visual) == TYPE_OBJECT and target_visual.is_type("Visual"):
		if not visuals.has(target_visual):
			# The target_visual has not been registered yet, so we register it 
			push_warning("FracVNE: target_visual has not been registered with VisualsManager.")
			add_visual(target_visual)
		target_visual.hide(animation)
	else:
		return FracVNE.StoryScript.Error.new("Expected target_visual to be a string or a Visual.")


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
