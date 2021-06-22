extends VBoxContainer

export var history_button_path: NodePath
export var save_button_path: NodePath
export var load_button_path: NodePath
export var options_button_path: NodePath
export var quit_button_path: NodePath
export var return_button_path: NodePath
export var menu_manager_path: NodePath
export var save_slots_menu_path: NodePath
export var pause_menu_path: NodePath

onready var history_button: Button = get_node(history_button_path)
onready var save_button: Button = get_node(save_button_path)
onready var load_button: Button = get_node(load_button_path)
onready var options_button: Button = get_node(options_button_path)
onready var quit_button: Button = get_node(quit_button_path)
onready var return_button: Button = get_node(return_button_path)
onready var menu_manager = get_node(menu_manager_path)
onready var save_slots_menu = get_node(save_slots_menu_path)
onready var pause_menu = get_node(pause_menu_path)

func _ready():
	history_button.connect("pressed", self, "_on_history_button_pressed")
	save_button.connect("pressed", self, "_on_save_button_pressed")
	load_button.connect("pressed", self, "_on_load_button_pressed")
	options_button.connect("pressed", self, "_on_options_button_pressed")
	quit_button.connect("pressed", self, "_on_quit_button_pressed")
	return_button.connect("pressed", self, "_on_return_button_pressed")

func _on_history_button_pressed():
	menu_manager.goto_menu("History")

func _on_save_button_pressed():
	save_slots_menu.start_save()

func _on_load_button_pressed():
	save_slots_menu.start_load()

func _on_options_button_pressed():
	menu_manager.goto_menu("Options")

func _on_quit_button_pressed():
	pause_menu.story_gui.quit()

func _on_return_button_pressed():
	pause_menu.toggle(false)
