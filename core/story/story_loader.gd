extends Node
# Loads stories from files and prepares them for execution by injecting
# story services and running the initialization calls on the story tree's nodes.


const SSUtils = FracVNE.StoryScript.Utils
const ProgramNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_node/program_node.gd")

export var services_holder_path: NodePath

var services: Array


func _ready() -> void:
	for child in get_node(services_holder_path).get_children():
		services.append(child)


# For now, the StoryLoader will only load stories from file paths.
# Loading regular story trees seems impractical at the moment, since you would
# not be able to save it unless you had some sort of "StoryManager" that kept
# track of every story and could fetch stories at will. Implementing a 
# StoryManager would also require tagging each story with a unique id.

# -- StoryScriptErrorable -- #
# Loads a story complete with a program root node.
# Returns the loaded story.
func load_story(story_file_path: String):
	# All stories are stored as just blocks, therefore we have to manually 
	# plug in the program node to act as the anchor to the entire story.
	var story_block = load_story_block(story_file_path)
	if not SSUtils.is_success(story_block):
		return SSUtils.stack_error(story_block, "Could not load the story block for a complete story.")
	
	var story_tree = ProgramNode.new(story_block)
	var result = story_tree._init_post()
	if not SSUtils.is_success(result):
		return SSUtils.stack_error(result, "Could not load story")
	
	for service in services:
		result = story_tree.add_service(service)
		if not SSUtils.is_success(result):
			return SSUtils.stack_error(result, "Could not configure a service for story.")
	
	result = story_tree.start_runtime_initialize()
	if not SSUtils.is_success(result):
		return SSUtils.stack_error(result, "Could not start_runtime_intiialize() for the story tree.")
	
	return story_tree


# -- StoryScriptErrorable -- #
# Loads a story file as a block that can
# then be attached to another story AST.
# Returns the loaded story block.
func load_story_block(story_file_path: String):
	var story_file = File.new()
	if not story_file.file_exists(story_file_path):
		return SSUtils.error("Could not find the story file at path \"%s\"" % story_file_path)
	
	var error = story_file.open_compressed(story_file_path, File.READ)
	if error != OK:
		return SSUtils.error("Could not open file. Got error code \"%s\"." % str(error))

	var json_result = JSON.parse(story_file.get_line())
	story_file.close()
	
	if json_result.error != OK:
		return SSUtils.error("Could not parse JSON for the story script at path: \"%s\"." % story_file_path)
	
	return SerializationUtils.deserialize(json_result.result)
