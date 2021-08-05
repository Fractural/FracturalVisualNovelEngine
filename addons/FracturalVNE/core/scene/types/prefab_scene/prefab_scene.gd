extends "res://addons/FracturalVNE/core/scene/types/scene.gd"
# BGScene that loads any arbitrary .tscn file as it's child


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("PrefabScene")
	return arr

# ----- Typeable ----- #


export var prefab: PackedScene


func _init(prefab_ = null):
	prefab = prefab_


func _get_controller_prefab():
	return preload("prefab_scene.tscn")


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
