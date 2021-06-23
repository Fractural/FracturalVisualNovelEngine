extends Node

signal quit()

export var text_printer_path: NodePath
export var pause_menu_path: NodePath

onready var text_printer = get_node(text_printer_path)
onready var pause_menu = get_node(pause_menu_path)

var story_director
var story_manager
var story_history

func _enter_tree():
	# TODO: Replace find_node with a more efficient method of gathering these
	# dependencies (Maybe service locate them?)
	var root = get_tree().root
	story_director = get_tree().root.find_node("StoryDirector", true, false)
	story_manager = get_tree().root.find_node("StoryManager", true, false)
	story_history = get_tree().root.find_node("StoryHistoryManager", true, false)

func quit():
	emit_signal("quit")
