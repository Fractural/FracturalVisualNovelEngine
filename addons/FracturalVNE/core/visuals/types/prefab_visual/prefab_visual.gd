extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #


const prefab_visual_prefab = preload("prefab_visual.tscn")

var prefab_path


func _init(cached_ = null, prefab_path_ = null).(cached_):
	prefab_path = prefab_path_


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
