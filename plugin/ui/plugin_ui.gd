tool
extends Control


const FracUtils = FracVNE.Utils

export var story_script_editor_path: NodePath
export var dep__plugin_path: NodePath

onready var story_script_editor = get_node(story_script_editor_path)
onready var plugin = FracUtils.get_valid_node_or_dep(self, dep__plugin_path, plugin)
onready var editor_filesystem = plugin.get_editor_interface().get_resource_filesystem()


func _setup_editor_assets(assets_registry) -> void:
	story_script_editor._setup_editor_assets(assets_registry)
	
	editor_filesystem.connect("filesystem_changed", story_script_editor, "refresh_file_display")
	story_script_editor.connect("saved_script", self, "_inside_plugin_on_saved_script")


# Updates script browser when the editor file system is changed.
func _inside_plugin_on_saved_script(script_path):
	editor_filesystem.scan()
