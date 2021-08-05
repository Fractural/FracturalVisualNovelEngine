extends Node


const SSUtils = FracVNE.StoryScript.Utils

export var transitioner_path: NodePath

onready var transitioner = get_node(transitioner_path)
onready var old_scene_controller: Node = $CanvasLayer/Control/ImageScene
onready var new_scene_controller: Node = $CanvasLayer/Control/ImageScene2
onready var cross_fade_transition = preload("res://addons/FracturalVNE/default_assets/transitions/cross_fade/cross_fade.tres")


func _ready() -> void:
	transitioner.init(self)
	
	transitioner.node_holder = new_scene_controller.get_node_holder()
	transitioner.old_node_holder = old_scene_controller.get_node_holder()
	
	var result = transitioner.replace(cross_fade_transition)
	if not SSUtils.is_success(result):
		print("ERROR: " + str(result))
		


# ----- Fake StoryDirector ----- #

func add_step_action(action):
	# Do nothing.
	print("Adding step action \"%s\" to StoryDirector." % str(action))


func remove_step_action(action):
	print("Removing step action \"%s\" from StoryDirector." % str(action))

# ----- Fake StoryDirector ----- #
