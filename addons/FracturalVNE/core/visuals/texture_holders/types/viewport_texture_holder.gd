extends "res://addons/FracturalVNE/core/visuals/texture_holders/texture_holder.gd"
# Keeps a viewport on at all times to get a texture.
# This allows for complex images created by multiple nodes
# to be rendered to a single texture.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ViewportTextureHolder")
	return arr

# ----- Typeable ----- #


export var viewport_path: NodePath

onready var viewport = get_node(viewport_path)


func get_holder_texture():
	var image = viewport.get_texture().get_data()
	image.flip_y()
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	return image_texture
