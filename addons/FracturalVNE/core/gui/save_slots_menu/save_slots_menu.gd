extends Control

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

onready var menu_manager = get_node(menu_manager_path)
onready var settings = get_node(settings_path)
onready var grid_container = get_node(grid_container_path)

var ui_save_slots = []
onready var save_manager = StoryServiceRegistry.get_service("StorySaveManager")

var mode: int = Mode.SAVE

func _ready():
	for i in range(save_manager.save_slots.size()):
		var slot = save_manager.save_slots[i]
		ui_save_slots.append(save_slot_prefab.instance())
		grid_container.add_child(ui_save_slots.back())
		ui_save_slots.back().init(i, slot)
		ui_save_slots.back().connect("save_slot_pressed", self, "on_save_slot_pressed")

func start_save():
	mode = Mode.SAVE
	menu_manager.goto_menu("SaveSlots", "Save")

func start_load():
	mode = Mode.LOAD
	menu_manager.goto_menu("SaveSlots", "Load")

func on_save_slot_pressed(slot_id):
	match mode:
		Mode.SAVE:
			emit_signal("picked_saved_state", slot_id)
		Mode.LOAD:
			emit_signal("picked_load_state", slot_id)
