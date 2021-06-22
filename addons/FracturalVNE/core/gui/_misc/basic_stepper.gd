extends Node

export var story_gui_path: NodePath

onready var story_gui: Node = get_node(story_gui_path)

# Steps the story whenever an unhandled mouse button is clicked

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		story_gui.story_director.try_step()
