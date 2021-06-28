tool
extends Node
# Runs a play test scene from the editor for the in-editor StoryScriptEditor.


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["StoryRunner", "EditorStoryRunner"]

# ----- Typeable ----- #


const Server = preload("res://addons/FracturalVNE/plugin/network/server.gd")

export var plugin_dep_path: NodePath

var server

onready var plugin_dep = get_node(plugin_dep_path)


func run(story_file_path: String, quit_to_scene: PackedScene = null):
	if not is_instance_valid(server):
		server = Server.new()
		add_child(server)
	server.story_file_path = story_file_path
	if quit_to_scene != null:
		server.quit_to_scene_path = quit_to_scene.get_path()
	
	var plugin = plugin_dep.dependency
	plugin.get_editor_interface().play_custom_scene("res://addons/FracturalVNE/plugin/ui/via_editor_story_init.tscn")
