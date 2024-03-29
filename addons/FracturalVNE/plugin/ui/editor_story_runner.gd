tool
extends Node
# Runs a play test scene from the editor for the in-editor StoryScriptEditor.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryRunner", "EditorStoryRunner"]

# ----- Typeable ----- #


const FracUtils = FracVNE.Utils
const Server = preload("res://addons/FracturalVNE/plugin/network/server.gd")

export var dep__persistent_data_path: NodePath
export var dep__plugin_path: NodePath

var server

onready var plugin 			= FracUtils.get_valid_node_or_dep(self, dep__plugin_path, plugin)
onready var persistent_data = FracUtils.get_valid_node_or_dep(self, dep__persistent_data_path, persistent_data)


func run(story_file_path: String, quit_to_scene: PackedScene = null):
	if not is_instance_valid(server):
		server = Server.new()
		server.persistent_data = persistent_data
		add_child(server)
	
	# Save the data so the latest version is accessible from the launched game.
	persistent_data.save_data_to_file()
	
	plugin.get_editor_interface().play_custom_scene("res://addons/FracturalVNE/plugin/via_editor_story_init.tscn")
