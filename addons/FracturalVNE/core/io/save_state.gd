extends Reference

var starting_node_id
var story_save_nodes
var story_file_path
var saved_date
var screenshot

# TODO: Add screenshots to save_state

func _init(story_file_path_ = null, starting_node_id_ = null, story_save_nodes_ = null, screenshot_ = null):
	story_file_path = story_file_path_
	starting_node_id = starting_node_id_
	story_save_nodes = story_save_nodes_
	screenshot = screenshot_
	saved_date = OS.get_time()

# ----- Serialization ----- #

func serialize():
	return {
		"script_path": "res://addons/FracturalVNE/core/io/save_state.gd",
		"story_file_path": story_file_path,
		"starting_node_id": starting_node_id,
		"story_save_nodes": story_save_nodes,
		"saved_date": saved_date,
	}

func deserialize(serialized_obj):
	var instance = get_script().new()
	instance.story_file_path = serialized_obj["story_file_path"]
	instance.starting_node_id = serialized_obj["starting_node_id"]
	instance.story_save_nodes = serialized_obj["story_save_nodes"]
	instance.saved_date = serialized_obj["saved_date"]
	return instance

func _to_string():
	return "SAVE STATE: [ID: %s, NODES: %s, FILEPATH: %s, DATE: %s]" % [str(starting_node_id), str(story_save_nodes), str(story_file_path), str(saved_date)]

# ----- Serialization ----- #
