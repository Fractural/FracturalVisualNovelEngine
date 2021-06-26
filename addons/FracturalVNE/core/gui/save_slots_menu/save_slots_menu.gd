extends Control
# Controls the ui for the save slots menu. Allows users to enter a saving or
# loading mode and lets users select a save slot to save to/load from.


enum Mode {
	SAVE,
	LOAD
}

signal picked_saved_state(slot_id)
signal picked_load_state(state)

export var menu_manager_path: NodePath
export var settings_path: NodePath
export var save_slot_prefab: PackedScene
export var grid_container_path: NodePath
export var save_manager_dep_path: NodePath

var ui_save_slots: Array = []
var mode: int = Mode.SAVE

onready var menu_manager = get_node(menu_manager_path)
onready var settings = get_node(settings_path)
onready var grid_container = get_node(grid_container_path)
onready var save_manager_dep = get_node(save_manager_dep_path)


func _ready():
	for i in range(save_manager_dep.dependency.save_slots.size()):
		var slot = save_manager_dep.dependency.save_slots[i]
		ui_save_slots.append(save_slot_prefab.instance())
		grid_container.add_child(ui_save_slots.back())
		ui_save_slots.back().construct(i, slot)
		ui_save_slots.back().connect("save_slot_pressed", self, "_on_save_slot_pressed")


func start_save():
	mode = Mode.SAVE
	menu_manager.goto_menu("SaveSlots", "Save")


func start_load():
	mode = Mode.LOAD
	menu_manager.goto_menu("SaveSlots", "Load")


func _on_save_slot_pressed(slot_id):
	match mode:
		Mode.SAVE:
			emit_signal("picked_saved_state", slot_id)
		Mode.LOAD:
			emit_signal("picked_load_state", slot_id)
