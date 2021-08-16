extends Node
# Initializes a text printer if it's placed directly in the scene tree instead
# of being loaded in game


const FracUtils = FracVNE.Utils

export var text_printer: Resource

export var dep__story_director_path: NodePath
export var dep__text_printer_manager_path: NodePath

onready var story_director = FracUtils.get_valid_node_or_dep(self, dep__story_director_path, story_director)
onready var text_printer_manager = FracUtils.get_valid_node_or_dep(self, dep__text_printer_manager_path, text_printer_manager)


func _ready() -> void:
	get_child(0).init(text_printer, story_director)
	# TODO: Implement support for swapping out the default printer and
	# 		also serializing the default printer.
	#		(Maybe have a check on startup that delete duplicate printers?)
	#		Or maybe have a method of serializing the state of a printer to
	#		avoid unecessary delete calls?)
	# 
	# We currently are not registering the default printers to avoid serialization.
	text_printer_manager.set_default_text_printer_controller(get_child(0))
