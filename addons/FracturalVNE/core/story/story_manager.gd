extends Node
# Responsible for running a story and exposing the signals emitted by the story
# (such as throw_error).


signal throw_error(error)

export var story_loader_path: NodePath
export var story_gui_configurer_path: NodePath
export var scene_manager_dep_path: NodePath

var story_tree
var story_file_path: String
var quit_to_scene: PackedScene

onready var story_loader = get_node(story_loader_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var scene_manager_dep = get_node(scene_manager_dep_path)

func _post_ready():
	story_gui_configurer.story_gui.connect("quit", self, "quit")


func run_story(story_file_path_: String):
	load_story(story_file_path_)
	story_tree.execute()


func load_story(story_file_path_: String):
	story_file_path = story_file_path_
	story_tree = story_loader.load_story(story_file_path)
	story_tree.connect("throw_error", self, "throw_error")
	
	print("LOADED TREE:")
	print(story_tree.debug_string(""))


func throw_error(error):
	emit_signal("throw_error", error)


func quit():
	scene_manager_dep.dependency.transition_to_scene(quit_to_scene)
