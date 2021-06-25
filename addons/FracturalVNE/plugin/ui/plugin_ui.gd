tool
class_name PluginUI
extends Control

export var story_script_editor_path: NodePath

onready var story_script_editor: StoryScriptEditor = get_node(story_script_editor_path)

func _setup_editor_assets(assets_registry):
	story_script_editor._setup_editor_assets(assets_registry)
