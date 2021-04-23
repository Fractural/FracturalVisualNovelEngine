extends Node
class_name StoryDecisionManager

export var decision_gui_path: NodePath
onready var decision_gui = get_node(decision_gui_path) 

var story_manager: StoryManager

func _init(story_manager_: StoryManager):
	story_manager = story_manager_

func if_cond(condition: bool):
	pass

func add_label(label: String):
	pass

func jump():
	pass

#TODO Finish deciision manager