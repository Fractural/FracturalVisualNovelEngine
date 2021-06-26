class_name DependencyRouter, "res://addons/FracturalVNE/assets/icons/branch.png"
extends Node
# Routes a dependency to multiple other dependencies


export var source_dependency_path: NodePath
export(Array, NodePath) var destination_dependency_paths


func _ready():
	var source_dependency = get_node(source_dependency_path)
	for path in destination_dependency_paths:
		get_node(path).dependency = source_dependency.dependency
