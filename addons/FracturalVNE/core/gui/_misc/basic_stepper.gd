extends Node
# Steps the story whenever an unhandled mouse button is clicked


onready var story_director = StoryServiceRegistry.get_service("StoryDirector")


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled()
		story_director.try_step()
