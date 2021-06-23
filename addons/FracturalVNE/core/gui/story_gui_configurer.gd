extends Node
# Configures StoryGUI by adding StoryGUI's services to the StoryConfigurer.
# Mediates interactions with gui and looks for the StoryUI in it's first child,
# which facilitates quick drag-and-drop implementation of new StoryGUI. 


const StoryGUI = preload("res://addons/FracturalVNE/core/gui/story_gui.gd")

export var story_configurer_path: NodePath
export var story_gui_holder_path: NodePath

var story_gui

onready var story_configurer = get_node(story_configurer_path)
onready var story_gui_holder = get_node(story_gui_holder_path)


func _ready():
	assert(story_gui_holder.get_child_count() == 1 and (story_gui_holder.get_child(0) is StoryGUI), "StoryGUIConfigurer must have a single StoryGUI node as a child.")
	story_gui = story_gui_holder.get_child(0)
	story_configurer.services.append(story_gui.text_printer)
