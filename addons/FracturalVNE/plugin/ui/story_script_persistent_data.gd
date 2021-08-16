tool
extends Node
# Holds persistent data for the StoryScriptEditor that lasts between the 
# play scene and the editor scene.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptPersistentData"]

# ----- Typeable ----- #


const FracUtils = FracVNE.Utils
const EDITOR_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/editor_persistent_data.json"
const STANDALONE_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/standalone_persistent_data.json"

var current_script_path: String = ""
var current_saved_story_path: String = ""
var current_directory_path: String = ""
var compiled: bool = false
var saved: bool = false

var _is_real_persistent_data: bool = false


func _enter_tree() -> void:
	if FracUtils.is_in_editor_scene_tab(self):
		return
	_is_real_persistent_data = true
	
	# We want to save before ready is called
	# on other nodes.
	print("Loaded persistent data")
	load_data_from_file()


func _notification(what) -> void:
	if _is_real_persistent_data and what == NOTIFICATION_PREDELETE:
		print("Saving while deleting")
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
	print("loading persistent data at: " + get_persistent_data_file_path())
	if file.file_exists(get_persistent_data_file_path()):
		print("Persistent file exists")
		var error = file.open(get_persistent_data_file_path(), File.READ)
		assert(error == OK, "Could not open persistent data file.")
		
		var json_result = JSON.parse(file.get_as_text())
		assert(json_result.error == OK, "Could not parse persistent data file's JSON.")
		
		print("json result: " + str(json_result.result))
		file.close()
		deserialize_state(json_result.result)
	else:
		print("Persistent data file path does not exist")
		save_data_to_file()


# ----- Serialization ----- #

func serialize_state():
	return {
		"current_story_script_path": current_script_path,
		"current_saved_story_path": current_saved_story_path,
		"current_directory_path": current_directory_path,
		"compiled": compiled,
		"saved": saved,
	}


func deserialize_state(serialized_state):
	current_script_path = serialized_state["current_story_script_path"]
	current_saved_story_path = serialized_state["current_saved_story_path"]
	current_directory_path = serialized_state["current_directory_path"]
	compiled = serialized_state["compiled"]
	saved = serialized_state["saved"]
	print("deserialized state for persist data. current_director_path: " + current_directory_path)

# ----- Serialization ----- #
