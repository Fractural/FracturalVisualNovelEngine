extends "res://addons/FracturalVNE/core/visuals/types/visual_controller.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #

const SSUtils = FracVNE.StoryScript.Utils

export var prefab_holder_path: NodePath

var prefab_instance

onready var prefab_holder = get_node(prefab_holder_path)


func init(visual_ = null, story_director_ = null):
	.init(visual_, story_director_)
	
	prefab_holder = get_node(prefab_holder_path)
	
	var prefab_result = SSUtils.load(get_visual().prefab_path)
	if not SSUtils.is_success(prefab_result):
		return prefab_result
	
	prefab_instance = prefab_result.instance()
	prefab_holder.add_child(prefab_instance)


# ----- Serialization ----- #

# prefab_visual_serializer.gd

# ----- Serialization ----- #
