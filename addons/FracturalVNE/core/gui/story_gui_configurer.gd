extends Node

const StoryGUI = preload("res://addons/FracturalVNE/core/gui/story_gui.gd")

export var story_configurer_path: NodePath

onready var story_configurer = get_node(story_configurer_path)

var story_gui

func _ready():
	assert(get_child_count() == 1 and (get_child(0) is StoryGUI), "StoryGUIConfigurer must have a single StoryGUI node as a child.")
	story_gui = get_child(0)
	story_configurer.services.append(story_gui.text_printer)
