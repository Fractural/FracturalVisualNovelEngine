extends "res://addons/FracturalVNE/core/visuals/texture_holders/texture_holder.gd"
# Depends on a builtin node to supply a texture.
# (Such as a Sprite or a TextureRect)


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleTextureHolder")
	return arr

# ----- Typeable ----- #


export var textured_node_path: NodePath
export var texture_property_name: String = "texture"

onready var textured_node = get_node(textured_node_path) 


func get_holder_texture():
	return textured_node.get(texture_property_name)
