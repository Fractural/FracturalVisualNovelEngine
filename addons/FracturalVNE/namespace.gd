class_name FracVNE
extends Reference
# Serves as a namespace for all FracVNE related classes


const Utils = preload("res://addons/FracturalVNE/core/utils/utils.gd")
# TODO: Maybe remove this along with SignalConnector related classes since
#		the signal connector feels too janky to use.
const InspectorUtils = preload("res://addons/FracturalVNE/core/utils/inspector_utils.gd")
const FuncCall = preload("res://addons/FracturalVNE/core/utils/func_call.gd")
const StoryScript = preload("res://addons/FracturalVNE/core/story_script/story_script_namespace.gd")


# ----- Static Methods ----- #

static func run_story(scene_tree: SceneTree, story_file_path: String):
	var instance = get_self_contained_story_runner().instance()
	scene_tree.root.add_child(instance)
	instance.run_story(story_file_path)


static func get_self_contained_story_runner():
	return load("res://addons/FracturalVNE/plugin/self_contained_story.tscn")

# ----- Static Methods ----- #
