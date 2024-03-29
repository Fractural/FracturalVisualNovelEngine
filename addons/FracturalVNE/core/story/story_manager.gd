extends Node
# Responsible for running a story and exposing the signals emitted by the story
# (such as throw_error).


signal throw_error(error)

const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils

export var story_loader_path: NodePath
export var dep__scene_manager_path: NodePath

var story_tree
var story_file_path: String
var quit_to_scene: PackedScene

onready var story_loader = get_node(story_loader_path)
onready var scene_manager = FracUtils.get_valid_node_or_dep(self, dep__scene_manager_path, scene_manager)


func run_story(story_file_path_: String):
	var error = load_story(story_file_path_)
	if not SSUtils.is_success(error):
		throw_error(SSUtils.stack_error(error, "Could not run the story."))
		return
	story_tree.execute()


# -- StoryScriptErrorable -- #
func load_story(story_file_path_: String):
	story_file_path = story_file_path_
	var story_tree_result = story_loader.load_story(story_file_path)
	if not SSUtils.is_success(story_tree_result):
		return story_tree_result
	story_tree = story_tree_result
	story_tree.connect("throw_error", self, "throw_error")


func throw_error(error):
	emit_signal("throw_error", error)
