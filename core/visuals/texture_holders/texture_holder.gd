extends "res://addons/FracturalVNE/core/standard_node_2d/standard_node_2d.gd"
# -- Abstract Class -- #
# Base class for all TextureHolders
# TextureHolders are node holders for actors which
# can return a texture of all the held nodes. 


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("TextureHolder")
	return arr

# ----- Typeable ----- #


func get_holder_texture():
	pass
