tool
extends EditorPlugin

const Settings: Script = preload("settings.gd")
const Docker: Script = preload("ui/docker.gd")
const PluginUIScene: PackedScene = preload("ui/plugin_ui.tscn")

var plugin_ui: Control
var docker: Docker
var settings: Settings

func _enter_tree() -> void:
	settings = Settings.new("Fractural Visual Novel Engine", "Fractural_VNE")
	plugin_ui = PluginUIScene.instance()
	docker = Docker.new(self, settings, plugin_ui)
	add_child(docker)

func _exit_tree() -> void:
	docker.free()
	plugin_ui.free()
