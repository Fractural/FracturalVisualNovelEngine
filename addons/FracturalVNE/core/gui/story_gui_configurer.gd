extends Node

export var story_configurer_path: NodePath

onready var story_configurer = get_node(story_configurer_path)

const StoryGUI = preload("res://addons/FracturalVNE/core/gui/story_gui.gd")

func _ready():
	assert(get_child_count() == 1 and (get_child(0) is StoryGUI), "StoryGUIConfigurer must have a single StoryGUI node as a child.")
	story_configurer.services.append(get_child(0).text_printer)

func get_story_gui():
	return get_child(0)
