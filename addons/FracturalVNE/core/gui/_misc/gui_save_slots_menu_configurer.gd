extends Node

export var save_slots_menu_path: NodePath
export var pause_menu_path: NodePath

onready var save_slots_menu = get_node(save_slots_menu_path)
onready var pause_menu = get_node(pause_menu_path)

func _post_ready():
	save_slots_menu.connect("picked_saved_state", self, "_on_picked_saved_state")
	save_slots_menu.connect("picked_load_state", self, "_on_picked_load_state")
	pause_menu.story_gui.story_manager.connect("state_saved", self, "_on_state_saved")

func _on_state_saved(state, slot_id):
	save_slots_menu.ui_save_slots[slot_id].init(slot_id, pause_menu.story_gui.story_manager.story_save_manager.save_slots[slot_id])

func _on_picked_saved_state(slot_id):
	pause_menu.story_gui.story_manager.save_current_state(slot_id)
	
func _on_picked_load_state(slot_id):
	if (pause_menu.story_gui.story_manager.try_load_save_slot(slot_id)):
		save_slots_menu.ui_save_slots[slot_id].init(pause_menu.story_gui.story_manager.save_slots[slot_id])
		pause_menu.show_settings(false)
