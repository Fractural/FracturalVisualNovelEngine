class_name FracVNE_Runnable_VariableRouter, "res://addons/FracturalVNE/assets/icons/variable_router.svg"
extends "linkable_runnable_behaviour.gd"


export var source_variable_name: String
export var source_node_path: NodePath

export var target_variable_name: String
export(Array, NodePath) var target_node_paths: Array


func run(args = []):
	var value = get_node(source_node_path).get(source_variable_name)
	for target_node_path in target_node_paths:
		get_node(target_node_path).set(target_variable_name, value)
