extends Control

export var story_gui_path: NodePath
export var menu_manager_path: NodePath
export var save_slots_menu_path: NodePath

onready var story_gui = get_node(story_gui_path)
onready var menu_manager = get_node(menu_manager_path)
onready var save_slots_menu = get_node(save_slots_menu_path)

func toggle(enabled):
	visible = enabled

func show_options():
	toggle(true)
	menu_manager.goto_menu("Options")

func show_save():
	toggle(true)
	save_slots_menu.start_save()

func show_load():
	toggle(true)
	save_slots_menu.start_load()

func show_history():
	toggle(true)
	menu_manager.goto_menu("History")
