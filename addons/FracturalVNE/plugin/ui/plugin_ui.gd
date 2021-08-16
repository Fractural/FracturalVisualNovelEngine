tool
extends Control


export var story_script_editor_path: NodePath
onready var story_script_editor = get_node(story_script_editor_path)


func _setup_editor_assets(assets_registry) -> void:
	story_script_editor._setup_editor_assets(assets_registry)
