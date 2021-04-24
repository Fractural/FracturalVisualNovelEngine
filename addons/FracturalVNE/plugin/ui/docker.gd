extends Node

enum DockType {
	LEFT_UPPER_LEFT, LEFT_BOTTOM_LEFT, LEFT_UPPER_RIGHT,
	LEFT_BOTTOM_RIGHT, RIGHT_UPPER_LEFT, RIGHT_BOTTOM_LEFT,
	RIGHT_UPPER_RIGHT, RIGHT_BOTTOM_RIGHT, BOTTOM_PANEL, 
	MAIN_PANEL,
}

const DockTypeDisplays: Dictionary = {
	0: "Left.UL Dock", 1: "Left.BL Dock", 2: "Left.UR Dock",
	3: "Left.BR Dock", 4: "Right.UL Dock", 5: "Right.BL Dock",
	6: "Right.UR Dock", 7: "Right.BR Dock", 8: "Bottom Panel",
	9: "Main Panel",
}

const Settings: Script = preload("../settings.gd")

var _settings : Settings

var _plugin: EditorPlugin
var _scene: Control
var _state: int
var _init_plugin_with_main_panel: bool
var _main_panel_constructed: bool
var _switched_out_of_main_panel: bool

func _init(plugin: EditorPlugin, settings: Settings, scene: Control) -> void:
	_plugin = plugin
	_scene = scene
	_settings = settings
	add_docker_type_setting()
	_state = get_window_state()
	
	_switched_out_of_main_panel = false
	_main_panel_constructed = false
	_init_plugin_with_main_panel = true
	# Assume that you are intializing plugin with the main panel
	# Then set to false if you are not
	if _init_plugin_with_main_panel and _state != DockType.MAIN_PANEL:
		_init_plugin_with_main_panel = false
	
	construct()
	
func _process(delta: float) -> void:
	update()
	
func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		deconstruct()

func construct() -> void:
	if _switched_out_of_main_panel:
		return
	
	if _state == DockType.BOTTOM_PANEL:
		_plugin.add_control_to_bottom_panel(_scene, _scene.name)
	elif _state == DockType.MAIN_PANEL:
		if _init_plugin_with_main_panel:
			_init_plugin_with_main_panel = false
			_main_panel_constructed = true
			_scene.visible = false
			_plugin.get_editor_interface().get_editor_viewport().add_child(_scene)
		else:
			push_warning("Fractural VNE Display changed to Main Panel. A plugin restart is required for display changes to take effect.")
	else:
		_plugin.add_control_to_dock(_state, _scene)

func deconstruct() -> void:
	if _state == DockType.BOTTOM_PANEL:
		_plugin.remove_control_from_bottom_panel(_scene)
	elif _main_panel_constructed or _state == DockType.MAIN_PANEL:
		# Deconstruction for the main_panel is already handled by plugin.gd 
		# since the plugin calls plugin_ui.free()
		return
	else:
		_plugin.remove_control_from_docks(_scene)

func update() -> void:
	var state = get_window_state()
	
	# If the user has switched out of the main panel or
	# iI the state has not changed,
	# then keep the display the same
	if state == _state:
		return
		
	# If new state is different and the main panel already exists
	# then lock display to main panel, since main panel can only be unloaded
	# when the plugin is disabled
	if state != DockType.MAIN_PANEL and _main_panel_constructed:
		_switched_out_of_main_panel = true
		push_warning("Fractural VNE Display was changed out of Main Panel to %s. A plugin restart is required for display changes to take effect." % DockTypeDisplays[state])
		_state = state
		return
		
	deconstruct()
	_state = state
	construct()

	_settings.set_setting("Display", _state)
	_settings.save()

func get_window_state() -> int:
	return _settings.get_setting("Display")

func add_docker_type_setting() -> void:
	_settings.add_setting("Display", TYPE_INT, DockType.MAIN_PANEL, PROPERTY_HINT_ENUM, PoolStringArray(DockTypeDisplays.values()).join(","))
	_settings.save()
