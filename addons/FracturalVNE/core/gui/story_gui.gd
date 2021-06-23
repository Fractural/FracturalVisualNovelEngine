extends Node
# Base StoryGUI that exposes basic GUI components to other classes.


signal quit()

export var text_printer_path: NodePath
export var pause_menu_path: NodePath

onready var text_printer = get_node(text_printer_path)
onready var pause_menu = get_node(pause_menu_path)


func quit():
	emit_signal("quit")
