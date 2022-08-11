class_name FracVNE_SingleVisual
extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"
# Builds SingleVisuals.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var texture: Texture


func _init(cached_ = false, texture_ = null).(cached_):
	texture = texture_


func _get_controller_prefab():
	return preload("single_visual.tscn")


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
