extends Node
# Steps the story whenever an unhandled mouse button is clicked


export var story_director_dep_path: NodePath

onready var story_director_dep = get_node(story_director_dep_path)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		story_director_dep.dependency.try_step()
