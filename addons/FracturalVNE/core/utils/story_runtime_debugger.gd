extends Node

export var story_manager_path: NodePath
export var quit_button_path: NodePath
export var error_popup_path: NodePath
export var error_text_path: NodePath

onready var story_manager: = get_node(story_manager_path)
onready var quit_button: Button = get_node(quit_button_path)
onready var error_popup: Popup = get_node(error_popup_path)
onready var error_text: RichTextLabel = get_node(error_text_path)

func _enter_tree():
	StoryServiceRegistry.add_service(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		StoryServiceRegistry.remove_service(self)

func _ready():
	quit_button.connect("pressed", self, "_on_quit_button_pressed")

func popup_error(error):
	error_popup.popup()
	error_text.bbcode_text = str(error)

func _on_quit_button_pressed():
	story_manager.quit()
