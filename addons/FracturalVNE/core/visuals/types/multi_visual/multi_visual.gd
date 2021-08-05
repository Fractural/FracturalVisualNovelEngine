class_name FracVNE_MultiVisual
extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisual")
	return arr

# ----- Typeable ----- #


export var textures_directory: String


func _init(cached_ = false, textures_directory_ = "").(cached_):
	textures_directory = textures_directory_


func _get_controller_prefab():
	return preload("multi_visual.tscn")


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["textures_directory"] = textures_directory
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.textures_directory = serialized_object["textures_directory"]
	return instance

# ----- Serialization ----- #
