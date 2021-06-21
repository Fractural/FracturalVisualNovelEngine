extends Node

func run(story_file_path):
	get_tree().change_scene("res://addons/FracturalVNE/core/story/story.tscn")
	
	yield(get_tree(), "idle_frame")
	
	StoryServiceRegistry.get_service("StoryConfigurer").load_story(story_file_path)
