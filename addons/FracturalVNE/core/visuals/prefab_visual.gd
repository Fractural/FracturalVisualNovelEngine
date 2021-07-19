extends "visual.gd"


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

func serialize():	
	return {
		"script_path": get_script().get_path(),
		"prefab_path": prefab_path,
		"visible": visible,
	}


func deserialize(serialized_obj):
	var visual_prefab = load("res://addons/FracturalVNE/core/visuals/prefab_visual.tscn")
	
	var instance = visual_prefab.new()
	
	instance.init(serialized_obj["prefab_path"])
	instance.visible = serialized_obj["visible"]
	
	return instance

# ----- Serialization ----- #