extends Node
# Runs a story from a file path


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryRunner"]

# ----- Typeable ----- #


export var scene_manager_path: NodePath

var story_file_path: String
var quit_to_scene: PackedScene

onready var scene_manager = get_node(scene_manager_path)


func run(story_file_path_: String, quit_to_scene_: PackedScene = null):
	story_file_path = story_file_path_
	quit_to_scene = quit_to_scene_
	scene_manager.transition_to_scene("res://addons/FracturalVNE/core/story/story.tscn")
