extends "res://addons/FracturalVNE/core/scene/types/scene.gd"
# BGScene that loads any arbitrary .tscn file as it's child


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("PrefabScene")
	return arr

# ----- Typeable ----- #


var prefab_path


func _init(prefab_path_):
	controller_prefab = preload("prefab_scene.tscn")
	prefab_path = prefab_path_
