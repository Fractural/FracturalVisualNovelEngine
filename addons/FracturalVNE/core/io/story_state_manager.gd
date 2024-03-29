extends Node
# Manages the state of the current story by saving or loading new states.


signal save_state_started(save_state)
signal state_loaded(save_state, slot_id)
signal state_saved(save_state, slot_id)

const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils
const SaveState = preload("res://addons/FracturalVNE/core/io/save_state.gd")

export var screenshot_manager_path: NodePath
export var story_manager_path: NodePath
export var story_director_path: NodePath
export var ast_node_locator_path: NodePath
export var dep__save_manager_path: NodePath

onready var screenshot_manager = get_node(screenshot_manager_path)
onready var story_manager = get_node(story_manager_path)
onready var story_director = get_node(story_director_path)
onready var ast_node_locator = get_node(ast_node_locator_path)
onready var save_manager = FracUtils.get_valid_node_or_dep(self, dep__save_manager_path, save_manager)


func save_current_state(save_slot_id: int):
	story_director.skip(true)
	
	screenshot_manager.screenshot_gameplay()
	
	yield(screenshot_manager, "finished_screenshot")

	var thumbnail = _get_thumbnail_from(screenshot_manager.screenshot)
	
	# serialize_state() propagates a call through the AST that populates serialized_nodes.
	var serialized_state = story_manager.story_tree.serialize_state()

	assert(story_director.curr_stepped_node != null, "StoryDirector.curr_node is null, therefore cannot save current state.")

	var state = SaveState.new(story_manager.story_file_path, story_director.curr_stepped_node.reference_id, serialized_state, thumbnail)
	
	save_manager.save_state_to_slot(state, save_slot_id)
	
	story_director.release_queued_overridden_steps()
	
	emit_signal("state_saved", state, save_slot_id)


# -- StoryScriptErrorable -- #
func load_save_slot(save_slot_id: int):	
	var state = save_manager.get_save_slot(save_slot_id)
	var result = story_manager.load_story(state.story_file_path)
	if not SSUtils.is_success(result):
		return result
	story_manager.story_tree.deserialize_state(state.story_tree_state)
	story_director.start_step(ast_node_locator.find_node_with_id(state.starting_node_id))
	if story_director.curr_stepped_node.is_auto_step() == true:
		story_director.step()
	emit_signal("state_loaded", state, save_slot_id)


# Returns true if save slot was successfully loaded.
# If a StoryScriptError occurs, it will be thrown to 
# StoryManager and the function will return false.
func try_load_save_slot(save_slot_id: int):
	if not save_manager.has_save_slot(save_slot_id):
		return false
	var result = load_save_slot(save_slot_id)
	if not SSUtils.is_success(result):
		story_manager.throw_error(result)
		return false
	return true


func _get_thumbnail_from(texture: Texture):
	var image: Image = texture.get_data()
	image.resize(512, 512 * texture.get_data().get_height() / texture.get_data().get_width())

	var new_texture = ImageTexture.new()
	new_texture.create_from_image(image)

	return new_texture
