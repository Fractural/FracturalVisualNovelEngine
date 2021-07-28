extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Fades a node in or out.


export var fade_curve: Curve
export var reverse_curve: bool
export var iterator_behaviour_path: NodePath
export var node_holder_path: NodePath

onready var iterator = get_node(iterator_behaviour_path)
onready var node_holder = get_node(node_holder_path)


func run(args = []):
	node_holder.modulate.a = fade_curve.interpolate((1 - iterator.percentage) if reverse_curve else iterator.percentage)
