class_name FracVNE_SingleVisual
extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"
# Builds SingleVisuals.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var texture_path: String


func _init(cached_ = false, texture_path_ = "").(cached_):
	texture_path = texture_path_


func _get_controller_prefab_path():
	return preload("single_visual.tscn")


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["texture_path"] = texture_path
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.texture_path = serialized_object["texture_path"]
	return instance

# ----- Serialization ----- #
