class_name FracVNE_StandardNode2DTransition, "res://addons/FracturalVNE/assets/icons/transition.svg"
extends Resource
# Holds information about the show, hide, and replace transitions.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2DTransition"]

# ----- Typeable ----- #


export var show_transition: PackedScene
export var hide_transition: PackedScene
export var replace_transition: PackedScene
