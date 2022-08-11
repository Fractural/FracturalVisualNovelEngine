extends Node
# Configures StoryGUI by adding StoryGUI's services to the StoryLoader.
# Mediates interactions between the story gui and other classes.


const StoryGUI = preload("res://addons/FracturalVNE/core/gui/story_gui.gd")

export var story_loader_path: NodePath
export var story_gui_holder_path: NodePath

var story_gui

onready var story_loader = get_node(story_loader_path)
onready var story_gui_holder = get_node(story_gui_holder_path)


func _ready() -> void:
	# Looks for the StoryGUI in it's first child, 
	# which facilitates quick drag-and-drop implementation of new StoryGUI. 
	assert(story_gui_holder.get_child_count() == 1 and (story_gui_holder.get_child(0) is StoryGUI), "StoryGUIConfigurer must have a single StoryGUI node as a child.")
	story_gui = story_gui_holder.get_child(0)
