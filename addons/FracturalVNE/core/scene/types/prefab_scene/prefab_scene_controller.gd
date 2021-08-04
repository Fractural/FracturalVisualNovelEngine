extends "res://addons/FracturalVNE/core/scene/types/scene_controller.gd"
# Scene that holds a prefab.


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("PrefabSceneController")
	return arr

# ----- Typeable ----- #


export var prefab_holder_path: NodePath

onready var prefab_holder = get_node(prefab_holder_path)


func init(scene_ = null, story_director_ = null):
	.init(scene_, story_director_)
	prefab_holder.add_child(scene_.prefab.instance())


# ----- Serialization ----- #

# prefab_scene_controller_serializer.gd

# ----- Serialization ----- #
