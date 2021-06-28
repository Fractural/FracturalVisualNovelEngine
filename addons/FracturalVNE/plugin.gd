tool
extends EditorPlugin


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["Plugin"]

# ----- Typeable ----- #


const Settings: Script = preload("plugin/settings.gd")
const Docker: Script = preload("plugin/ui/docker.gd")
const PluginUIScene: PackedScene = preload("plugin/ui/plugin_ui.tscn")

var plugin_ui: PluginUI
var docker: Docker
var settings: Settings

var assets_registry = PluginAssetsRegistry.new(self)


func _init():
	settings = Settings.new("Fractural Visual Novel Engine", "Fractural_VNE")


func _enter_tree():
	plugin_ui = PluginUIScene.instance()
	
	plugin_ui.get_node("Dependencies/PluginDependency").dependency_path = get_path()
	plugin_ui._settings = settings
	
	docker = Docker.new(self, settings, plugin_ui)
	add_child(docker)


func _ready():
	plugin_ui._setup_editor_assets(assets_registry)


func _exit_tree():
	docker.free()
	plugin_ui.free()


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
