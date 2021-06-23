extends Node

const SaveState = preload("res://addons/FracturalVNE/core/io/save_state.gd")

signal save_state_started(save_state)

signal state_loaded(save_state, slot_id)
signal state_saved(save_state, slot_id)

export var story_director_path: NodePath
export var ast_node_manager_path: NodePath
export var story_configurer_path: NodePath
export var story_gui_configurer_path: NodePath
export var screenshot_manager_path: NodePath

onready var story_director = get_node(story_director_path)
onready var ast_node_manager = get_node(ast_node_manager_path)
onready var story_configurer = get_node(story_configurer_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var screenshot_manager = get_node(screenshot_manager_path)

var story_save_manager = StoryServiceRegistry.get_service("StorySaveManager")
var quit_to_scene: PackedScene

func _enter_tree():
	StoryServiceRegistry.add_service(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		StoryServiceRegistry.remove_service(self)

func _post_ready():
	story_configurer.connect("initialized_story", self, "_on_initialized_story")
	story_gui_configurer.story_gui.connect("quit", self, "quit")

func run_story(story_file_path):
	story_configurer.load_story(story_file_path)

func quit():
	# TODO: Add a transition to the quit to scene using a transition manager
	get_tree().change_scene_to(quit_to_scene)

func _on_initialized_story(story_tree):
	# Only runs once on initialize
	story_configurer.disconnect("initialized_story", self, "_on_initialized_story")
	story_tree.execute()

# TODO: Abstract saving into a LocalStorySaveManager

func save_current_state(save_slot_id: int):
	screenshot_manager.screenshot()
	
	yield(screenshot_manager, "finished_screenshot")

	# Serialized node data are stored in a dict as:
	# 	Key: The serialized node's reference id
	# 	Value: The serialized data for that node
	var serialized_nodes = {}
	# start_serialize_save propagates a call through the AST that populates serialized_nodes.
	story_configurer.story_tree.start_serialize_save(serialized_nodes)
	assert(story_director.curr_stepped_node != null, "StoryDirector.curr_node is null, therefore cannot save current state.")
	
	var state = SaveState.new(story_configurer.story_file_path, story_director.curr_stepped_node.reference_id, serialized_nodes, screenshot_manager.screenshot)
	
	story_save_manager.save_state(state, save_slot_id)
	emit_signal("state_saved", state, save_slot_id)

func load_save_slot(save_slot_id: int):	
	var state = story_save_manager.get_save_slot(save_slot_id)
	story_configurer.load_story(state.story_tree)
	# The StoryDirector is primed to go the the next node, since the
	# StoryDirector calls the execute method of the next node
	story_director.start_step(ast_node_manager.find_node_with_id(state.starting_node_id))
	emit_signal("state_loaded", state, save_slot_id)

# Returns true if save slot was successfully loaded.
func try_load_save_slot(save_slot_id: int):
	if not story_save_manager.has_save_slot(save_slot_id):
		return false
	load_save_slot(save_slot_id)
	return true
