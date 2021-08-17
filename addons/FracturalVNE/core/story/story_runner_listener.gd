extends Node


const FracUtils = FracVNE.Utils

export var story_manager_path: NodePath
export var dep__story_runner_path: NodePath

onready var story_manager = get_node(story_manager_path)
onready var story_runner = FracUtils.get_valid_node_or_dep(self, dep__story_runner_path, story_runner)

func _post_ready():
	story_manager.quit_to_scene = story_runner.quit_to_scene
	story_manager.run_story(story_runner.story_file_path)
