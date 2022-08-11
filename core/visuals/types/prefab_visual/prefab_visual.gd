class_name FracVNE_PrefabVisual
extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #


export var prefab: PackedScene


func _init(cached_ = false, prefab_ = null).(cached_):
	prefab = prefab_


func _get_controller_prefab():
	return preload("prefab_visual.tscn")


# ----- Serialization ----- #

func serialize() -> Dictionary:
	var serialized_object = .serialize()
	serialized_object["prefab_path"] = prefab.get_path()
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)
	instance.prefab = load(serialized_object["prefab_path"])
	return instance

# ----- Serialization ----- #
