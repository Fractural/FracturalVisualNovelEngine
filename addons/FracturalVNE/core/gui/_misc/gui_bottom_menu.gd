extends Node
# Wires up the bottom menu of the story GUI to the appropriate actions


export var history_button_path: NodePath
export var skip_button_path: NodePath
export var auto_button_path: NodePath
export var save_button_path: NodePath
export var load_button_path: NodePath
export var options_button_path: NodePath
export var pause_menu_path: NodePath
export var story_director_dep_path: NodePath

var pressed_state_button_count: int = 0

onready var history_button: Button = get_node(history_button_path)
onready var skip_button: Button = get_node(skip_button_path)
onready var auto_button: Button = get_node(auto_button_path)
onready var save_button: Button = get_node(save_button_path)
onready var load_button: Button = get_node(load_button_path)
onready var options_button: Button = get_node(options_button_path)
onready var pause_menu = get_node(pause_menu_path)
onready var story_director_dep = get_node(story_director_dep_path)


func _ready() -> void:
	history_button.connect("pressed", self, "_on_history_button_pressed")
	skip_button.connect("toggled", self, "_on_skip_button_toggled")
	auto_button.connect("toggled", self, "_on_auto_button_toggled")
	save_button.connect("pressed", self, "_on_save_button_pressed")
	load_button.connect("pressed", self, "_on_load_button_pressed")
	options_button.connect("pressed", self, "_on_options_button_pressed")


func _on_history_button_pressed():
	pause_menu.show_history()


func _on_skip_button_toggled(enabled):
	if enabled:
		auto_button.pressed = false
	
	_update_step_state()


func _on_auto_button_toggled(enabled):
	if enabled:
		if skip_button.pressed:
			skip_button.pressed = false
			return
	
	_update_step_state()


func _on_save_button_pressed():
	pause_menu.show_save()


func _on_load_button_pressed():
	pause_menu.show_load()


func _on_options_button_pressed():
	pause_menu.show_options()


func _update_step_state():
	if skip_button.pressed:
		story_director_dep.dependency.step_state = story_director_dep.dependency.StepState.SKIPPING
	elif auto_button.pressed:
		story_director_dep.dependency.step_state = story_director_dep.dependency.StepState.AUTO_STEP
	else:
		story_director_dep.dependency.step_state = story_director_dep.dependency.StepState.MANUAL
