extends Node

export var history_button_path: NodePath
export var skip_button_path: NodePath
export var auto_button_path: NodePath
export var save_button_path: NodePath
export var load_button_path: NodePath
export var options_button_path: NodePath
export var pause_menu_path: NodePath
export var story_gui_path: NodePath

onready var history_button: Button = get_node(history_button_path)
onready var skip_button: Button = get_node(skip_button_path)
onready var auto_button: Button = get_node(auto_button_path)
onready var save_button: Button = get_node(save_button_path)
onready var load_button: Button = get_node(load_button_path)
onready var options_button: Button = get_node(options_button_path)
onready var pause_menu = get_node(pause_menu_path)
onready var story_gui = get_node(story_gui_path)

func _ready():
	history_button.connect("pressed", self, "_on_history_button_pressed")
	skip_button.connect("toggled", self, "_on_skip_button_toggled")
	auto_button.connect("toggled", self, "_on_auto_button_toggled")
	save_button.connect("pressed", self, "_on_save_button_pressed")
	load_button.connect("pressed", self, "_on_load_button_pressed")
	options_button.connect("pressed", self, "_on_options_button_pressed")

func _on_history_button_pressed():
	pause_menu.show_history()

func _on_skip_button_toggled(enabled):
	story_gui.story_director.skipping = enabled

func _on_auto_button_toggled(enabled):
	story_gui.story_director.auto_step = enabled

func _on_save_button_pressed():
	pause_menu.show_save()

func _on_load_button_pressed():
	pause_menu.show_load()

func _on_options_button_pressed():
	pause_menu.show_options()
