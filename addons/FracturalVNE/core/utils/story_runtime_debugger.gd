extends Node
# Catchs the error messages emitted by a story and displays them to the user.


export var story_manager_path: NodePath
export var story_runner_listener_path: NodePath
export var quit_button_path: NodePath
export var error_ui_path: NodePath
export var error_text_path: NodePath

onready var story_manager: = get_node(story_manager_path)
onready var story_runner_listener = get_node(story_runner_listener_path)
onready var quit_button: Button = get_node(quit_button_path)
onready var error_ui: Control = get_node(error_ui_path)
onready var error_text: TextEdit = get_node(error_text_path)


func _ready() -> void:
	error_ui.visible = false
	quit_button.connect("pressed", self, "_on_quit_button_pressed")
	story_manager.connect("throw_error", self, "popup_error")


func popup_error(error):
	error_ui.visible = true
	error_text.text = error.runtime_error_string()


func _on_quit_button_pressed():
	print("_on_quit_button_pressed")
	story_runner_listener.quit()
