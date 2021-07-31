class_name FracVNE_PrefabVisual
extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #


export var prefab_path: String


func _init(cached_ = false, prefab_path_ = "").(cached_):
	prefab_path = prefab_path_


func _get_controller_prefab_path():
	return preload("prefab_visual.tscn")


# ----- Serialization ----- #

func serialize():
	var serialized_object = .serialize()
	serialized_object["prefab_path"] = prefab_path
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.prefab_path = serialized_object["prefab_path"]
	return instance

# ----- Serialization ----- #
