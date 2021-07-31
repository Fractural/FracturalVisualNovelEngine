extends Node
# Initializes a text printer if it's placed directly in the scene tree instead
# of being loaded in game


export var text_printer: Resource
export var story_director_dep_path: NodePath
export var text_printer_manager_dep_path: NodePath

onready var story_director_dep = get_node(story_director_dep_path)
onready var text_printer_manager_dep = get_node(text_printer_manager_dep_path)


func _ready():
	print("Printer init running!")
	get_child(0).init(text_printer, story_director_dep.dependency)
	text_printer_manager_dep.dependency.default_text_printer_controller = get_child(0)
