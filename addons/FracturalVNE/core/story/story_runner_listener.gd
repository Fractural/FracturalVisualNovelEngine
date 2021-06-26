extends Node

export var story_manager_path: NodePath
export var story_runner_dep_path: NodePath

onready var story_manager = get_node(story_manager_path)
onready var story_runner_dep = get_node(story_runner_dep_path)

func _post_ready():
	story_manager.quit_to_scene = story_runner_dep.dependency.quit_to_scene
	story_manager.run_story(story_runner_dep.dependency.story_file_path)
