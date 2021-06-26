extends Node
# Loads stories from files and prepares them for execution by injecting
# story services and running the initialization calls on the story tree's nodes.


export var services_holder_path: NodePath

var services: Array


func _ready():
	for child in get_node(services_holder_path).get_children():
		services.append(child)


# For now, the StoryLoader will only load stories from file paths.
# Loading regular story trees seems impractical at the moment, since you would
# not be able to save it unless you had some sort of "StoryManager" that kept
# track of every story and could fetch stories at will. Implementing a 
# StoryManager would also require tagging each story with a unique id.
func load_story(story_file_path):
	var story_file = File.new()
	story_file.open_compressed(story_file_path, File.READ)
	var json_result = JSON.parse(story_file.get_line())
	story_file.close()
	
	assert(json_result.error == OK, 'Could not load story script at path: "%s"' % story_file_path)
	
	var story_tree = SerializationUtils.deserialize(json_result.result)
	
	for service in services:
		story_tree.add_service(service)
	
	story_tree.start_runtime_initialize()
	
	return story_tree
