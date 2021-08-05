extends "res://addons/FracturalVNE/core/scene/types/scene.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("ImageScene")
	return arr

# ----- Typeable ----- #


var texture: Texture


func _init(texture_ = null):
	texture = texture_


func _get_controller_prefab():
	return preload("image_scene.tscn")


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["texture_path"] = texture.get_path()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.texture = load(serialized_object["texture_path"])
	return instance

# ----- Serialization ----- #
