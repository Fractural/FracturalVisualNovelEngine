class_name FracVNE_Runnable_CallBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_call.svg"
extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# Call a function on an object.
# This can be used to terminate a chain.


export var receiver_path: NodePath
export var function_name: String

onready var receiver = get_node(receiver_path)


func run(args = []):
	receiver.call(function_name)
