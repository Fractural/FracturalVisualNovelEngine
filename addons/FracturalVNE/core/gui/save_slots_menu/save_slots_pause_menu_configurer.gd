extends Node
# Configures SaveSlotsMenu for the runtime pause menu GUI.
# Lets players load and save scenes during gameplay. 


export var save_slots_menu_path: NodePath
export var pause_menu_path: NodePath
export var story_state_manager_dep_path: NodePath

onready var save_slots_menu = get_node(save_slots_menu_path)
onready var pause_menu = get_node(pause_menu_path)
onready var story_state_manager_dep = get_node(story_state_manager_dep_path)


func _post_ready():
	story_state_manager_dep.dependency.connect("state_saved", self, "_on_state_saved")
	save_slots_menu.connect("picked_saved_state", self, "_on_picked_saved_state")
	save_slots_menu.connect("picked_load_state", self, "_on_picked_load_state")


func _on_state_saved(state, slot_id):
	save_slots_menu.ui_save_slots[slot_id].construct(slot_id, story_state_manager_dep.dependency.story_save_manager_dep.dependency.save_slots[slot_id])


func _on_picked_saved_state(slot_id):
	story_state_manager_dep.dependency.save_current_state(slot_id)


func _on_picked_load_state(slot_id):
	if (story_state_manager_dep.dependency.try_load_save_slot(slot_id)):
		save_slots_menu.ui_save_slots[slot_id].construct(slot_id, story_state_manager_dep.dependency.story_save_manager_dep.dependency.save_slots[slot_id])
		pause_menu.toggle(false)
