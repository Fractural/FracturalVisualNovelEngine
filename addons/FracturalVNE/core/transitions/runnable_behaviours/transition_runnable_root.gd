extends "res://addons/FracturalVNE/core/runnable_behaviour/runnable_root.gd"
# Takes in a transition and converts into a runnable call


export var transition_path: NodePath

onready var transition = get_node(transition_path)


func _ready():
	transition.connect("_transition", self, "_transition")


func _transition():
	runnable.run()
