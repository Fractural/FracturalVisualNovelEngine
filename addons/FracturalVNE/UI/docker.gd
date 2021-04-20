extends Node

enum DockType {
	LEFT_UPPER_LEFT, LEFT_BOTTOM_LEFT, LEFT_UPPER_RIGHT,
	LEFT_BOTTOM_RIGHT, RIGHT_UPPER_LEFT, RIGHT_BOTTOM_LEFT,
	RIGHT_UPPER_RIGHT, RIGHT_BOTTOM_RIGHT, BOTTOM_PANEL,
	OUT_OF_BOUNDS
}

const DockTypeDisplays: Dictionary = {
	0: "Left.UL Dock", 1: "Left.BL Dock", 2: "Left.UR Dock",
	3: "Left.BR Dock", 4: "Right.UL Dock", 5: "Right.BL Dock",
	6: "Right.UR Dock", 7: "Right.BR Dock", 8: "Bottom Panel",
}

const Settings: Script = preload("../settings.gd")

var _settings : Settings

var _plugin: EditorPlugin
var _scene: Control
var _state: int

func _init(plugin: EditorPlugin, settings: Settings, scene: Control) -> void:
	_plugin = plugin
	_scene = scene
	_settings = settings
	construct()
	
func _process(delta: float) -> void:
	update()
	
func _notification(what) -> void:
	if what == NOTIFICATION_PREDELETE:
		deconstruct()

func construct() -> void:
	add_docker_type_setting()
	
	_state = get_window_state()
	
	if _state == DockType.BOTTOM_PANEL:
		_plugin.add_control_to_bottom_panel(_scene, _scene.name)
	else:
		_plugin.add_control_to_dock(_state, _scene)

func deconstruct() -> void:
	if _state == DockType.BOTTOM_PANEL:
		_plugin.remove_control_from_bottom_panel(_scene)
	else:
		_plugin.remove_control_from_docks(_scene)

func update() -> void:
	var state = get_window_state()
	if state == _state:
		return
		
	deconstruct()
	_state = state
	construct()

	_settings.set_setting("Display", _state)
	_settings.save()

func get_window_state() -> int:
	return _settings.get_setting("Display")

func add_docker_type_setting() -> void:
	_settings.add_setting("Display", TYPE_INT, DockType.BOTTOM_PANEL, PROPERTY_HINT_ENUM, PoolStringArray(DockTypeDisplays.values()).join(","))
	_settings.save()
