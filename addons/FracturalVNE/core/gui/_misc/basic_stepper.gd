extends Node
# Steps the story whenever an unhandled mouse button is clicked


const FracUtils = FracVNE.Utils

export var dep__story_director_path: NodePath

onready var story_director = FracUtils.get_valid_node_or_dep(self, dep__story_director_path, story_director)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		story_director.dependency.try_step()
