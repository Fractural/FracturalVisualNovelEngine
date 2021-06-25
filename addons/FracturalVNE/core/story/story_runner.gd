extends Node

func run(story_file_path: String, quit_to_scene: PackedScene = null):
	get_tree().change_scene("res://addons/FracturalVNE/core/story/story.tscn")
	
	yield(get_tree(), "idle_frame")
	
	var story_manager = StoryServiceRegistry.get_service("StoryManager")
	story_manager.quit_to_scene = quit_to_scene
	story_manager.run_story(story_file_path)
