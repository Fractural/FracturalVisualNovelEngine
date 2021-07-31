class_name FracVNE_Visual_ABSTRACT, "res://addons/FracturalVNE/assets/icons/visual.svg"
extends "res://addons/FracturalVNE/core/actor/actor.gd"
# Responsible for holding data about visuals and also building them.
# Base class for all VisualBlueprints.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("Visual")
	return arr

# ----- Typeable ----- #


func _init(cached_ = false).(cached_):
	pass
