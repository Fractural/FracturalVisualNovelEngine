tool
class_name Dependency, "res://addons/FracturalVNE/assets/icons/dependency.png"
extends Node
# A node that represents an external node dependency of a scene


export var dependency_name: String
export var dependency_path: NodePath

var dependency


func _ready():
	assert(get_node(dependency_path) != null, "Missing external dependency!")
	
	if get_node(dependency_path).get_script() != null and get_node(dependency_path).get_script().get_path() == get_script().get_path():
		# Allows for the chaining of dependencies
		dependency = get_node(dependency_path).dependency
	else:
		dependency = get_node(dependency_path)
