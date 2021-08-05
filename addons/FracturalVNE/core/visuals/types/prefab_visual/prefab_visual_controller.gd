extends "res://addons/FracturalVNE/core/visuals/types/visual_controller.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisualController")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var prefab_holder_path: NodePath

var prefab_instance

onready var prefab_holder = get_node(prefab_holder_path)


func init(visual_ = null, story_director_ = null):
	.init(visual_, story_director_)
	
	prefab_holder = get_node(prefab_holder_path)
	
	prefab_instance = get_visual().prefab.instance()
	prefab_holder.add_child(prefab_instance)


# ----- Serialization ----- #

# prefab_visual_serializer.gd

# ----- Serialization ----- #
