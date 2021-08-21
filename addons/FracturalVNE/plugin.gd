tool
extends EditorPlugin


const FracUtils = FracVNE.Utils
const PersistentData: Script = preload("plugin/ui/persistent_data/persistent_data.gd")
const EditorPersistentDataDefualtsLoader = preload("plugin/ui/persistent_data/editor_persistent_data_defaults_loader.gd")
const Docker: Script = preload("plugin/ui/docker.gd")
const PluginUI: Script = preload("plugin/ui/plugin_ui.gd")
const AssetsRegistry: Script = preload("plugin/plugin_assets_registry.gd")
const PluginUIScene: PackedScene = preload("plugin/ui/plugin_ui.tscn")

var inspector_plugins = []

var plugin_ui: PluginUI
var backup_ui
var docker: Docker

# plugin.gd gets it's own AssetsRegistry
# this is needed for get_plugin_icon() to work.
var assets_registry
var persistent_data
var persistent_data_defaults_loader

# Holds optional modules for this plugin.
var plugin_modules = []


func _init():
	assets_registry = AssetsRegistry.new(self)
	
	# true makes the PersistentData ready immediately,
	# which loads the peristent data from the file, etc
	persistent_data = PersistentData.new()
	persistent_data_defaults_loader = EditorPersistentDataDefualtsLoader.new(persistent_data, assets_registry)
	
	# TODO DISCUSS: Maybe just refactor PersistentData into 
	# 				a Refernce PersistentData and a Node wrapper
	#				for the Reference PersistentData?
	#				This would allow us to stop using
	#				hacks like calling _ready() manually.
	#
	# We force a ready in order to let the data load
	persistent_data._ready()


func _enter_tree():
	add_child(assets_registry)
	add_child(persistent_data)
	
	plugin_ui = PluginUIScene.instance()
	FracUtils.try_inject_dependency(self, plugin_ui)
	FracUtils.try_inject_dependency(assets_registry, plugin_ui)
	FracUtils.try_inject_dependency(persistent_data, plugin_ui)
	
	docker = Docker.new(self, persistent_data, plugin_ui)
	add_child(docker)
	
	inspector_plugins = []
	_setup_inspector_plugins()

	_load_plugin_modules()
	
# Not using ASCII art since it takes up too much space in the console
# 888888 88""Yb    db     dP""b8     Yb    dP 88b 88 888888 
# 88__   88__dP   dPYb   dP   `"      Yb  dP  88Yb88 88__   
# 88""   88"Yb   dP__Yb  Yb            YbdP   88 Y88 88""   
# 88     88  Yb dP"\"""Yb  YboodP        YP    88  Y8 888888 

	push_warning("You may change any setting for Fractural VNE by clicking the \"Settings\" button in the story script editor or by editing \"FracturalVNE/editor_persistent_data.json\"")


func _ready() -> void:
	plugin_ui._setup_editor_assets(assets_registry)


func _exit_tree():
	FracUtils.try_free(docker)
	FracUtils.try_free(plugin_ui)
	
	for inspector_plugin in inspector_plugins:
		remove_inspector_plugin(inspector_plugin)
	
	FracUtils.try_free(assets_registry)


func _load_plugin_modules():
	# ----- Mono ----- #
	
	load_plugin_module("res://addons/FracturalVNE/_modules/mono/PluginModule.cs")
	
	# ----- Mono ----- #


func _setup_inspector_plugins():
	add_custom_inspector_plugin(load("res://addons/FracturalVNE/core/utils/signals/signal_connector_inspector.gd").new())


func load_plugin_module(module_path: String):
	var file = File.new()
	if not file.file_exists(module_path):
		return
	var module = ResourceLoader.load(module_path)
	if module == null:
		return
	
	print("FracVNE: Loaded plugin module -> \"%s\"" % module_path)
	plugin_modules.append(module.new(self))


func add_custom_inspector_plugin(instance: EditorInspectorPlugin):
	if instance.has_method("_setup_editor_assets"):
		instance._setup_editor_assets(assets_registry)
	add_inspector_plugin(instance)
	inspector_plugins.append(instance)


func has_main_screen():
	if docker != null:
		return docker._main_panel_constructed
	return persistent_data.display_mode == Docker.DockType.MAIN_PANEL


func make_visible(visible):
	if plugin_ui:
		plugin_ui.visible = visible
	else:
		push_warning("plugin_ui does not exist, therefore we cannot call \"make_visible(%s)\". Is this intentional? " % str(visible))


func get_plugin_name():
	return "Story Script"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return assets_registry.load_asset("assets/icons/script.svg")
