tool
extends Control


export var story_script_editor_path: NodePath

var _settings

onready var story_script_editor = get_node(story_script_editor_path)


func _ready() -> void:
	if FracVNE.Utils.is_in_editor_scene_tab(self):
		return
	
	_add_port_setting()


func _add_port_setting() -> void:
	_settings.add_setting("Port", TYPE_INT, 6010)
	_settings.save()


func _setup_editor_assets(assets_registry) -> void:
	story_script_editor._setup_editor_assets(assets_registry)
