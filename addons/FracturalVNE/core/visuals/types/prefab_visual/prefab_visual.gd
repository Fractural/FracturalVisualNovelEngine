extends "res://addons/FracturalVNE/core/visuals/types/visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #


export var prefab_holder_path: NodePath

var prefab_instance
var prefab_holder


func _ready():
	if prefab_holder == null:
		prefab_holder = get_node(prefab_holder_path)


func init_(story_director_, prefab_instance_):
	init(story_director_)
	
	prefab_holder = get_node(prefab_holder_path)
	
	prefab_instance = prefab_instance_
	prefab_holder.add_child(prefab_instance)


# ----- Serialization ----- #

# prefab_visual_serializer.gd

# ----- Serialization ----- #
