extends Node
# Holds persistent data for the StoryScriptEditor that lasts between the 
# play scene and the editor scene.


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)


static func get_types() -> Array:
	return ["StoryScriptPersistentData"]

# ----- Typeable ----- #


var current_script_path: String = ""
var current_saved_story_path: String = ""
var compiled: bool = false
var saved: bool = false

var service_already_exists: bool = false
var entered_tree_before: bool = false 
var service_di_container
