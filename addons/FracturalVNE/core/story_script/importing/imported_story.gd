extends Reference
# Holds data about an imported story. This data is used to serialize and
# deserialize imported stories in StoryImportManager.


var story_file_path: String
var node_reference_id: int


func _init(story_file_path_ = "", node_reference_id_ = 0):
	story_file_path = story_file_path_
	node_reference_id = node_reference_id_


# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"story_file_path": story_file_path,
		"node_reference_id": node_reference_id,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.story_file_path = serialized_object["story_file_path"]
	instance.node_reference_id = serialized_object["node_reference_id"]

# ----- Serialization ----- #
