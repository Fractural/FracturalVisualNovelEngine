tool
extends Node
# Holds persistent data for the StoryScriptEditor that lasts between the 
# play scene and the editor scene.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptPersistentData"]

# ----- Typeable ----- #


signal on_property_changed(variable, new_value)
signal get_defaults(persistent_data)

enum Mode {
	READ,
	WRITE,
	READ_AND_WRITE,
}

enum PersistentDataPath {
	EDITOR,
	STANDALONE,
	AUTO,
}

const FracUtils = FracVNE.Utils
const EDITOR_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/editor_persistent_data.json"
const STANDALONE_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/standalone_persistent_data.json"

export(PersistentDataPath) var persistent_data_path_type: int = PersistentDataPath.AUTO

var current_script_path: String 		setget _invalidate_set
var current_saved_story_path: String 	setget _invalidate_set
var current_directory_path: String 		setget _invalidate_set
var current_file_display_type: int 		setget _invalidate_set
var compiled: bool 						setget _invalidate_set
var saved: bool 						setget _invalidate_set
var main_hsplit_offset: int 			setget _invalidate_set

var _is_real_persistent_data: bool = false


func _ready() -> void:	
	if FracUtils.is_in_editor_scene_tab(self):
		return
	_is_real_persistent_data = true
	
	# We want to save before ready is called
	# on other nodes.
	load_data_from_file()


func _set_defaults():
	current_script_path = ""
	current_saved_story_path = ""
	current_directory_path = ""
	current_file_display_type = 0
	compiled = false
	saved = false
	main_hsplit_offset = 100

	emit_signal("get_defaults", self)


func _notification(what) -> void:
	if _is_real_persistent_data and what == NOTIFICATION_PREDELETE:
		save_data_to_file()


func set_property(prop_name: String, value):
	assert(prop_name in self, "Property \"%s\" does not exist in StoryScriptPersistentData." % prop_name)
	if get(prop_name) != value:
		set(prop_name, value)
		emit_signal("on_property_changed", value)


func get_persistent_data_file_path() -> String:
	match persistent_data_path_type:
		PersistentDataPath.AUTO:
			if Engine.is_editor_hint():
				return EDITOR_PERSISTENT_DATA_FILE_PATH
			else:
				return STANDALONE_PERSISTENT_DATA_FILE_PATH
		PersistentDataPath.STANDALONE:
			return STANDALONE_PERSISTENT_DATA_FILE_PATH
		PersistentDataPath.EDITOR:
			return EDITOR_PERSISTENT_DATA_FILE_PATH
	push_error("Could not get the file path for the StoryScriptPersistentData!")
	return ""


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
		_set_defaults()
		save_data_to_file()


# ----- Serialization ----- #

func serialize_state():
	return {
		"current_story_script_path": current_script_path,
		"current_saved_story_path": current_saved_story_path,
		"current_directory_path": current_directory_path,
		"current_file_display_type": current_file_display_type,
		"compiled": compiled,
		"saved": saved,
		"main_hsplit_offset": main_hsplit_offset,
	}


func deserialize_state(serialized_state):
	current_script_path = 		_try_get_or_default(serialized_state, "current_story_script_path", 	current_script_path)
	current_saved_story_path = 	_try_get_or_default(serialized_state, "current_saved_story_path",	current_saved_story_path)
	current_directory_path = 	_try_get_or_default(serialized_state, "current_directory_path",		current_directory_path)
	current_file_display_type = _try_get_or_default(serialized_state, "current_file_display_type",	current_file_display_type)
	compiled = 					_try_get_or_default(serialized_state, "compiled",					compiled)
	saved = 					_try_get_or_default(serialized_state, "saved",						saved)
	main_hsplit_offset =		_try_get_or_default(serialized_state, "main_hsplit_offset",			main_hsplit_offset)


func _invalidate_set(value):
	assert(false, "Cannot directly set PersistentData properties. Use the PersistentData.set_property() method instead.")


# Allows for changing of what's serialized
# without having compatibility issues.
func _try_get_or_default(serialized_state: Dictionary, key: String, default_value):
	if serialized_state.has(key):
		return serialized_state[key]
	return default_value
	
# ----- Serialization ----- #
