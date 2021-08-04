extends "res://addons/FracturalVNE/core/standard_node_2d/node_2d_standard_node_2d.gd"
# -- Abstract Class -- #
# Base class for all TextureHolders
# TextureHolders are node holders for actors which
# can return a texture of all the held nodes. 


# ----- Typeable ----- #

func get_types() -> Array:
	return ["TextureHolder"]

# ----- Typeable ----- #


func get_holder_texture():
	pass
