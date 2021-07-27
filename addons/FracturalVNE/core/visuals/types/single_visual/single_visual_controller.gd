extends "res://addons/FracturalVNE/core/visuals/types/visual_controller.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var sprite_path: NodePath

onready var sprite = get_node(sprite_path)


# Since Godot does not support method overloading, I will add "_" to methods
# to indicate overloading.
func init(visual_, story_director_):
	.init(visual_, story_director_)
	
	sprite = get_node(sprite_path)
	sprite.texture = visual.texture


# ----- Serialization ----- #

# single_visual_serializer.gd

# ----- Serialization ----- #
