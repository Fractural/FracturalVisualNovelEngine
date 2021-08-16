tool
extends EditorPlugin


# ----- Typeable ----- #

func get_types() -> Array:
	return ["Plugin"]

# ----- Typeable ----- #


const FracUtils = FracVNE.Utils
const Settings: Script = preload("plugin/settings.gd")
const Docker: Script = preload("plugin/ui/docker.gd")
const PluginUI: Script = preload("plugin/ui/plugin_ui.gd")
const AssetsRegistry: Script = preload("plugin/plugin_assets_registry.gd")
const PluginUIScene: PackedScene = preload("plugin/ui/plugin_ui.tscn")

var inspector_plugins = []

var plugin_ui: PluginUI
var docker: Docker
var settings: Settings

# plugin.gd gets it's own AssetsRegistry
# this is needed for get_plugin_icon() to work.
var assets_registry = AssetsRegistry.new(self)


func _init():
	settings = Settings.new("Fractural Visual Novel Engine", "Fractural_VNE")


func _enter_tree():
	add_child(assets_registry)
	
	plugin_ui = PluginUIScene.instance()
	plugin_ui.get_node("Dependencies/PluginDependency").dependency_path = get_path()
	plugin_ui.get_node("Dependencies/AssetsRegistryDependency").dependency_path = assets_registry.get_path()
	plugin_ui._settings = settings
	
	docker = Docker.new(self, settings, plugin_ui)
	add_child(docker)
	
	inspector_plugins = []
	_setup_inspector_plugins()


func _ready() -> void:
	plugin_ui._setup_editor_assets(assets_registry)


func _exit_tree():
	docker.free()
	plugin_ui.free()
	
	for inspector_plugin in inspector_plugins:
		remove_inspector_plugin(inspector_plugin)
	
	assets_registry.free()


func _setup_inspector_plugins():
	add_custom_inspector_plugin(load("res://addons/FracturalVNE/core/utils/signals/signal_connector_inspector.gd").new())


func add_custom_inspector_plugin(instance: EditorInspectorPlugin):
	if instance.has_method("_setup_editor_assets"):
		instance._setup_editor_assets(assets_registry)
	add_inspector_plugin(instance)
	inspector_plugins.append(instance)


func has_main_screen():
	if docker != null:
		return docker._main_panel_constructed
	return settings.get_setting("Display") == Docker.DockType.MAIN_PANEL


func make_visible(visible):
	if plugin_ui:
		plugin_ui.visible = visible


func get_plugin_name():
	return "Story Script"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return assets_registry.load_asset("assets/icons/script.svg")
