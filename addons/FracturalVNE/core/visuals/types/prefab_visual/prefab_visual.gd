extends "res://addons/FracturalVNE/core/visuals/visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("PrefabVisual")
	return arr

# ----- Typeable ----- #


export var prefab_holder_path: NodePath

var prefab_path: String
var prefab_holder


func _ready():
	if prefab_holder == null:
		prefab_holder = get_node(prefab_holder_path)


func init_(story_director, prefab_path):
	init(story_director)
	
	prefab_holder = get_node(prefab_holder_path)
	
	prefab_holder.add_child(load(prefab_path).instance())


# ----- Serialization ----- #

# prefab_visual_serializer.gd

# ----- Serialization ----- #
