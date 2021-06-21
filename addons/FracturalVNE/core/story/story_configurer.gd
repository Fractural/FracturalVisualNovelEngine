extends Node

const ProgramNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/program_construct.gd").ProgramNode

signal initialized_story(story_tree)

export(Array, NodePath) var service_paths = []

var services: Array

var story_tree: ProgramNode
var story_file_path: String

var _readied = false
var _load_story_when_ready = false

func _enter_tree():
	StoryServiceRegistry.add_service(self)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		StoryServiceRegistry.remove_service("StoryConfigurer")

func _ready():
	for path in service_paths:
		services.append(get_node(path))
	_readied = true
	
	if _load_story_when_ready:
		load_story(story_tree)

# For now, the StoryConfigurer will only load stories from file paths.
# Loading regular story trees seems impractical at the moment, since you would
# not be able to save it unless you had some sort of "StoryManager" that kept
# track of every story and could fetch stories at will. Implementing a 
# StoryManager would also require tagging each story with a unique id.
func load_story(story_file_path_):
	story_file_path = story_file_path_
	
	var story_file = File.new()
	story_file.open_compressed(story_file_path_, File.READ)
	var json_result = JSON.parse(story_file.get_line())
	story_file.close()
	
	assert(json_result.error == OK, 'Could not load story script at path: "%s"' % story_file_path)
	
	story_tree = SerializationUtils.deserialize(json_result.result)
	
	# Prevents start story from running before the story configurer is ready.
	# All services must be loaded before we can start a new story.
	if not _readied:
		_load_story_when_ready = true
		return
	
	for service in services:
		story_tree.add_service(service)
	story_tree.start_configure_services()
	
	story_tree.start_runtime_initialize()
	
	emit_signal("initialized_story", story_tree)
