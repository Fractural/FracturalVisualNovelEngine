extends Node

const StoryGUI = preload("res://addons/FracturalVNE/core/gui/story_gui.gd")

export var story_configurer_path: NodePath
export var story_gui_holder_path: NodePath

onready var story_configurer = get_node(story_configurer_path)
onready var story_gui_holder = get_node(story_gui_holder_path)

var story_gui

func _ready():
	assert(story_gui_holder.get_child_count() == 1 and (story_gui_holder.get_child(0) is StoryGUI), "StoryGUIConfigurer must have a single StoryGUI node as a child.")
	story_gui = story_gui_holder.get_child(0)
	story_configurer.services.append(story_gui.text_printer)
	
#	story_gui.pause_menu.get_parent().remove_child(story_gui.pause_menu)
#	add_child(story_gui.pause_menu)
#	story_gui.pause_menu.owner = self
#
#	story_gui.get_parent().remove_child(story_gui)
#	gameplay_viewport.add_child(story_gui)
#	story_gui.owner = gameplay_viewport
