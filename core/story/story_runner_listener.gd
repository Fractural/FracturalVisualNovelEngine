extends Node


const FracUtils = FracVNE.Utils

export var story_manager_path: NodePath
export var story_gui_configurer_path: NodePath
export var dep__story_runner_path: NodePath

onready var story_manager = get_node(story_manager_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var story_runner = FracUtils.get_valid_node_or_dep(self, dep__story_runner_path, story_runner)


var _post_readied: bool = false
func _post_ready():
	story_gui_configurer.story_gui.connect("quit", self, "quit")
	story_manager.run_story(story_runner.story_file_path)


func quit():
	story_runner._close_story()
