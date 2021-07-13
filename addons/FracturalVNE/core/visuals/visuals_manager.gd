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
		StoryScriptFuncDef.new("show", [
			StoryScriptParameter.new("visual"),
			StoryScriptParameter.new("modifiers"),
			StoryScriptParameter.new("animation"),
		]),
		StoryScriptFuncDef.new("hide", [
			StoryScriptParameter.new("visual"),
			StoryScriptParameter.new("animation"),
		]),
	]


func configure_service(program_node):
	visuals = []


func get_service_name():
	return "VisualsManager"

# ----- StoryService ----- #


const SingleVisual = preload("single_visual.gd")
const MultiVisual = preload("multi_visual.gd")

export var reference_registry_path: NodePath
export var story_gui_configurer_path: NodePath
export var visual_controllers_holder_path: NodePath

var visuals: Array
var visual_controllers: Dictionary

onready var reference_registry = get_node(reference_registry_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var visual_controllers_holder = get_node(visual_controllers_holder_path)


func add_visual(visual):
	visuals.append(visual)

	# TODO NOW Part 1: Change all the visuals to
	#			directly be a visual controller. There is no point in separating
	#			data and behaviour for visuals using the "Visual" and "VisualController"
	#			structure due to only using visuals at runtime. Note that serialization
	#			should also work for nodes without any problems. 
	
	#			Remember to create a new instance of the node in the deserialize() 
	# 			function of the serializable node.

	# Part 2: Create the show and hide statements and let them accept modifiers after
	#			the visual variable. Don't forget to add type checking to these statements that
	#			throw runtime StoryScriptErrors!
	
	var visual_controller = Sprite.new()
	visual_controller.visible = false
	visual_controllers[visual] = visual_controller


func DynamicVisual(textures_directory):
	if typeof(textures_directory) != TYPE_STRING:
		return StoryScriptError.new("Expected textures_directory to be a string.")
	
	var new_visual = MultiVisual.new(load(textures_directory))
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)


func Visual(texture_path):
	if typeof(texture_path) != TYPE_STRING:
		return StoryScriptError.new("Expected texture_path to be a string.")
	
	var new_visual = SingleVisual.new(load(texture_path))
	reference_registry.add_reference(new_visual)
	add_visual(new_visual)


func set_visibility(target_visual, is_visible, animation):
	if typeof(target_visual) == TYPE_STRING:
		for stored_visual in visuals:
			if stored_visual.name == target_visual:
				return set_visibility(target_visual, is_visible, animation)
	elif typeof(target_visual) == TYPE_OBJECT and target_visual.is_type("Visual"):
		if not visuals.has(target_visual):
			# The target_visual has not been registered yet, so we register it 
			push_warning("FracVNE: target_visual has not been registered with VisualsManager.")
			add_visual(target_visual)
		visual_controllers[target_visual].visible = is_visible
		visual_controllers[target_visual].play_animation(animation)
	else:
		return StoryScriptError.new("Expected target_visual to be a string or a Visual.")


func show(target_visual, modifiers_string = null, animation = null):
	if modifiers_string != null and typeof(modifiers_string) == TYPE_STRING:
		visual_controllers[target_visual].set_sprite(target_visual.get_texture(modifiers_string))
	return set_visibility(target_visual, true, animation)


func hide(target_visual, animation = null):
	return set_visibility(target_visual, false, animation)


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
	visuals = []
	for visual_id in serialized_state["visual_ids"]:
		visuals.append(reference_registry.get_reference(visual_id))

# ----- Serialization ----- #
