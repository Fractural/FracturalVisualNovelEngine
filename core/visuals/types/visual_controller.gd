extends "res://addons/FracturalVNE/core/actor/actor_controller.gd"
# -- Abstract Class -- #
# Base class for all VisualControllers.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("VisualController")
	return arr

# ----- Typeable ----- #


func get_visual():
	return get_actor()
