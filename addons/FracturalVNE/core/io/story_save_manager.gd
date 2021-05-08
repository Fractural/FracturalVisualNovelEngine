extends Node

const SaveState = preload("res://addons/FracturalVNE/core/io/save_state.gd")

signal save_state_started(save_state)

signal state_loaded(state)
signal state_saved(save_state)

const MAX_SAVE_SLOTS = 6

export var story_director_path: NodePath
export var ast_node_manager_path: NodePath
export var story_configurer_path: NodePath

onready var story_director = get_node(story_director_path)
onready var ast_node_manager = get_node(ast_node_manager_path)
onready var story_configurer = get_node(story_configurer_path)

var saves_files_directory
var save_slots = []
var quick_save_state: SaveState

var _is_loading_state = false

func _ready():
	story_configurer.connect("initialized_story", self, "_on_initialized_story")
	load_save_slots()

func _on_initialized_story(story_tree):
	# Only runs once on initialize
	story_tree.execute()
	story_configurer.disconnect("initialized_story", self, "_on_initialized_story")

func save_current_state():
	assert(story_director.curr_stepped_node != null, "StoryDirector.cur_node is null, therefore cannot save current state.")
	save_state(SaveState.new(story_configurer.story_file_path, story_director.curr_stepped_node.reference_id, story_configurer.story_tree.start_serialize_save()))

func load_save_slots():
	save_slots = []
	for i in range(MAX_SAVE_SLOTS):
		var save_file = File.new()
		save_file.open_compressed(saves_files_directory + "/save_slot_" + str(i + 1) + ".save", File.READ)
		assert(save_file == OK, "Could not load save slot #%s." % str(i + 1))
		save_slots.append(SerializationUtils.deserialize(save_file.get_line()))
		save_file.close()

func save_state(state: SaveState):
	emit_signal("save_state_started", state)
	# TODO: Implement ui that listens for save_state_started and calls save_to_slot when user
	# clicks on a specific slot.

func load_state(state: SaveState):
	emit_signal("loaded_state", state)
	story_configurer.load_story(state.story_tree)
	
	story_director.start_step(ast_node_manager.find_node_with_id(state.starting_node_id))

func save_to_slot(save_state, save_slot):
	save_slots[save_slot] = save_state
	var save_file = File.new()
	save_file.open_compressed(saves_files_directory + "/save_slot_" + str(save_slot + 1) + ".save", File.WRITE)
	save_file.store_line(save_state.serialize())
	save_file.close()
	
	# TODO: Write file saving.

#TODO Write save manager
