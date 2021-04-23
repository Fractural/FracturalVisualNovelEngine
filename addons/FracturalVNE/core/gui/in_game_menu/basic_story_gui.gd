extends Node
class_name BasicStoryGUI

var story_manager: StoryManager
var story_save_manager: StorySaveManager

export var story_log_path: NodePath;
onready var story_log = get_node(story_log_path)

func _init(story_manager_, story_save_manager_):
	story_save_manager = story_save_manager_
	story_manager = story_manager_

func save():
	story_save_manager.save()

func load():
	story_save_manager.load()

func toggle_auto(enabled: bool):
	story_manager.auto_step = enabled

func toggle_story_log():
	toggle(story_log)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
