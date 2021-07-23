extends "res://addons/FracturalVNE/core/scene/types/scene.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("ImageScene")
	return arr

# ----- Typeable ----- #


export var sprite_path: NodePath

onready var sprite = get_node(sprite)
