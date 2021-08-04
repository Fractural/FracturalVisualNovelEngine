class_name FracVNE_BGScene, "res://addons/FracturalVNE/assets/icons/bg_scene.svg"
extends "res://addons/FracturalVNE/core/actor/actor.gd"
# Base class for all scenes


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("BGScene")
	return arr

# ----- Typeable ----- #


func _init(cached_ = false).(cached_):
	pass
