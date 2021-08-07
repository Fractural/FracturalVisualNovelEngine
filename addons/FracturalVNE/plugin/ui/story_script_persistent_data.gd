tool
extends Node
# Holds persistent data for the StoryScriptEditor that lasts between the 
# play scene and the editor scene.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptPersistentData"]

# ----- Typeable ----- #


const EDITOR_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/editor_persistent_data.json"
const STANDALONE_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/standalone_persistent_data.json"

var current_script_path: String = ""
var current_saved_story_path: String = ""
var compiled: bool = false
var saved: bool = false


func _ready() -> void:
	load_data_from_file()


func _notification(what) -> void:
    if what == MainLoop.NOTIFICATION_PREDELETE:
        save_data_to_file()


func get_persistent_data_file_path() -> String:
	if Engine.is_editor_hint():
		return EDITOR_PERSISTENT_DATA_FILE_PATH
	else:
		return STANDALONE_PERSISTENT_DATA_FILE_PATH


func save_data_to_file():
	var file = File.new()
	var error = file.open(get_persistent_data_file_path(), File.WRITE)
	if error == OK:
		file.store_string(JSON.print(serialize_state()))
		file.close()


func load_data_from_file():
	var file = File.new()
	if file.file_exists(get_persistent_data_file_path()):
		var error = file.open(get_persistent_data_file_path(), File.READ)
		assert(error == OK, "Could not open persistent data file.")
		
		var json_result = JSON.parse(file.get_as_text())
		assert(json_result.error == OK, "Could not parse persistent data file's JSON.")
		
		file.close()
		deserialize_state(json_result.result)
	else:
		save_data_to_file()


# ----- Serialization ----- #

func serialize_state():
	return {
		"current_story_script_path": current_script_path,
		"current_saved_story_path": current_saved_story_path,
		"compiled": compiled,
		"saved": saved,
	}


func deserialize_state(serialized_state):
	current_script_path = serialized_state["current_story_script_path"]
	current_saved_story_path = serialized_state["current_saved_story_path"]
	compiled = serialized_state["compiled"]
	saved = serialized_state["saved"]

# ----- Serialization ----- #
