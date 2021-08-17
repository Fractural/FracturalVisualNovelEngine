tool
extends Node
# Holds persistent data for the StoryScriptEditor that lasts between the 
# play scene and the editor scene.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["FracVNEPersistentData"]

# ----- Typeable ----- #


signal on_property_changed(variable, new_value)
signal get_defaults(persistent_data)

enum PersistentDataType {
	EDITOR,
	STANDALONE,
	AUTO,
}

const FracUtils = FracVNE.Utils
const EDITOR_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/editor_persistent_data.json"
const STANDALONE_PERSISTENT_DATA_FILE_PATH: String = "res://addons/FracturalVNE/standalone_persistent_data.json"

export(PersistentDataType) var persistent_data_type: int = PersistentDataType.AUTO

var current_script_path: String
var current_saved_story_path: String
var current_directory_path: String
var current_file_display_type: int
var compiled: bool
var saved: bool
var main_hsplit_offset: int
var port: int
var display_mode: int
var via_editor_window_size: Vector2

var _is_real_persistent_data: bool = false


func _ready() -> void:	
	if FracUtils.is_in_editor_scene_tab(self):
		return
	_is_real_persistent_data = true
	
	# We want to save before ready is called
	# on other nodes.
	load_data_from_file()


func _set_defaults():
	current_script_path 		= ""
	current_saved_story_path 	= ""
	current_directory_path 		= ""
	current_file_display_type 	= 0
	compiled 					= false
	saved 						= false
	main_hsplit_offset 			= 100
	port 						= 6010
	display_mode 				= 9		# Main Panel
	via_editor_window_size		= Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

	emit_signal("get_defaults", self)


func _notification(what) -> void:
	if _is_real_persistent_data and what == NOTIFICATION_PREDELETE:
		save_data_to_file()


func set_property(prop_name: String, value, emit_set_signal: bool = true):
	assert(prop_name in self, "Property \"%s\" does not exist in FracVNEPersistentData." % prop_name)
	if get(prop_name) != value:
		set(prop_name, value)
		if emit_set_signal:
			emit_signal("on_property_changed", prop_name, value)


func get_persistent_data_file_path() -> String:
	match persistent_data_type:
		PersistentDataType.AUTO:
			if Engine.is_editor_hint():
				return EDITOR_PERSISTENT_DATA_FILE_PATH
			else:
				return STANDALONE_PERSISTENT_DATA_FILE_PATH
		PersistentDataType.STANDALONE:
			return STANDALONE_PERSISTENT_DATA_FILE_PATH
		PersistentDataType.EDITOR:
			return EDITOR_PERSISTENT_DATA_FILE_PATH
	push_error("Could not get the file path for the FracVNEPersistentData!")
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
		"port": port,
		"display_mode": display_mode,
		"via_editor_window_size": SerializationUtils.serialize_vec2(via_editor_window_size),
	}


func deserialize_state(serialized_state):
	current_script_path			= _try_get_or_default(serialized_state, "current_story_script_path", 	current_script_path)
	current_saved_story_path	= _try_get_or_default(serialized_state, "current_saved_story_path",		current_saved_story_path)
	current_directory_path		= _try_get_or_default(serialized_state, "current_directory_path",		current_directory_path)
	current_file_display_type	= _try_get_or_default(serialized_state, "current_file_display_type",	current_file_display_type)
	compiled					= _try_get_or_default(serialized_state, "compiled",						compiled)
	saved						= _try_get_or_default(serialized_state, "saved",						saved)
	main_hsplit_offset			= _try_get_or_default(serialized_state, "main_hsplit_offset",			main_hsplit_offset)
	port						= _try_get_or_default(serialized_state, "port", 						port)
	display_mode				= _try_get_or_default(serialized_state, "display_mode",					display_mode)
	if serialized_state.has("via_editor_window_size"):
		via_editor_window_size = SerializationUtils.deserialize_vec2(serialized_state["via_editor_window_size"])


# Allows for changing of what's serialized
# without having compatibility issues.
func _try_get_or_default(serialized_state: Dictionary, key: String, default_value):
	if serialized_state.has(key):
		return serialized_state[key]
	return default_value
	
# ----- Serialization ----- #
