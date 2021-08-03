class_name FracVNE_ActorTransition, "res://addons/FracturalVNE/assets/icons/transition.svg"
extends Resource
# Responsible for transitioning from one Node2D to another Node2D.
# Base class for all Transitions.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorTransition"]

# ----- Typeable ----- #


export var show_transition: PackedScene
export var hide_transition: PackedScene
export var replace_transition: PackedScene
