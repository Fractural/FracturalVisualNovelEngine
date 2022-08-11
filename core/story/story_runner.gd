extends Node
# Runs a story from a file path


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryRunner"]

# ----- Typeable ----- #


# Emitting when reached the end of a story
signal story_finished()
# Emitted when either the user reaches the end
# of a story or if the user presses the quit button
signal story_closed()

export var scene_manager_path: NodePath

export var story_file_path: String
export var quit_to_scene: PackedScene

onready var scene_manager = get_node(scene_manager_path)


func run(story_file_path_: String = "", quit_to_scene_: PackedScene = null):
	if story_file_path_ != "":
		story_file_path = story_file_path_
	if quit_to_scene_ != null:
		quit_to_scene = quit_to_scene_
	scene_manager.transition_to_scene("res://addons/FracturalVNE/core/story/story.tscn")


func _close_story():
	emit_signal("story_closed")
	if quit_to_scene != null:
		scene_manager.transition_to_scene(quit_to_scene)


func _finish_story():
	emit_signal("story_closed")
	emit_signal("story_finished")
