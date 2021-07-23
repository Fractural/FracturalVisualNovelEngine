extends "res://addons/FracturalVNE/core/visuals/visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var sprite_path: NodePath

var texture: Texture
var sprite


func _ready():
	if sprite == null:
		sprite = get_node(sprite_path)


# Since Godot does not support method overloading, I will add "_" to methods
# to indicate overloading.
func init_(story_director, texture_):
	init(story_director)
	
	sprite = get_node(sprite_path)
	
	texture = texture_
	sprite.texture = texture


# ----- Serialization ----- #

# single_visual_serializer.gd

# ----- Serialization ----- #
