extends Reference

var starting_node_id
var story_save_nodes
var story_file_path

func _init(story_file_path_ = null, starting_node_id_ = null, story_save_nodes_ = null):
	story_file_path = story_file_path_
	starting_node_id = starting_node_id_
	story_save_nodes = story_save_nodes_

# ----- Serialization ----- #

func serialize():
	return {
		"script_path": "res://addons/FracturalVNE/core/io/save_state.gd",
		"story_file_path": story_file_path,
		"starting_node_id": starting_node_id,
		"story_save_nodes": story_save_nodes,
	}

func deserialize(serialized_obj):
	var instance = get_script().new()
	instance.story_file_path = serialized_obj["story_file_path"]
	instance.starting_node_id = serialized_obj["starting_node_id"]
	instance.story_save_nodes = serialized_obj["story_save_nodes"]
	return instance

# ----- Serialization ----- #
