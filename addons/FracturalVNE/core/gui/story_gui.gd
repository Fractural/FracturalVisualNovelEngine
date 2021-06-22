extends Node

signal quit()

export var text_printer_path: NodePath

onready var text_printer = get_node(text_printer_path)

var story_director
var story_manager
var story_history

func _enter_tree():
	var story_services_holder = get_node("../..")
	
	story_director = story_services_holder.find_node("StoryDirector")
	story_manager = story_services_holder.find_node("StoryManager")
	story_history = story_services_holder.find_node("StoryHistoryManager")

func quit():
	emit_signal("quit")
