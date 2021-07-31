extends "res://addons/FracturalVNE/core/actor/actor_controller.gd"
# Base class for all VisualControllers.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["VisualController"]

# ----- Typeable ----- #


func get_visual():
	return get_actor()
