extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisual")
	return arr

# ----- Typeable ----- #


const multi_visual_prefab = preload("multi_visual.tscn")

var textures_directory


func _init(cached_ = null, textures_directory_ = null).(cached_):
	textures_directory = textures_directory_


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["textures_directory"] = textures_directory
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.textures_directory = serialized_object["textures_directory"]
	return instance

# ----- Serialization ----- #
