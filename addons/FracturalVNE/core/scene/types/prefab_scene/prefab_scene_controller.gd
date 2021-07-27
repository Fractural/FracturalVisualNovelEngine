extends "res://addons/FracturalVNE/core/scene/types/scene.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("PrefabSceneController")
	return arr

# ----- Typeable ----- #


func init(scene):
	.init(scene)
	var prefab_result = SSUtils.load(scene.prefab_path)
	if not SSUtils.is_success(prefab_result):
		return prefab_result


# ----- Serialization ----- #

# prefab_scene_controller_serializer.gd

# ----- Serialization ----- #
