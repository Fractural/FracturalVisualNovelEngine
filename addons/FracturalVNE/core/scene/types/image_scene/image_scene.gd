extends "res://addons/FracturalVNE/core/scene/types/scene.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("ImageScene")
	return arr

# ----- Typeable ----- #


var texture_path


func _init(texture_path_ = null):
	controller_prefab = preload("image_scene.tscn")
	texture_path = texture_path_


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["texture_path"] = texture_path
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.texture_path = load(serialized_object["texture_path"])
	return instance

# ----- Serialization ----- #
