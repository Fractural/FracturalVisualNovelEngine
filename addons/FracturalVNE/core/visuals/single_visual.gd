extends "visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var sprite_path: NodePath

var texture: Texture
var sprite


func _ready():
	if sprite == null:
		sprite = get_node(sprite_path)


# Since Godot does not support method overloading, I will add "_" to methods
# to indicate overloading.
func init_(story_director, texture_):
	init(story_director)
	
	sprite = get_node(sprite_path)
	
	texture = texture_
	sprite.texture = texture


# ----- Serialization ----- #

func serialize():	
	return {
		"script_path": get_script().get_path(),
		"texture_path": texture.get_path(),
		"visible": visible,
	}


func deserialize(serialized_obj):
	var visual_prefab = load("res://addons/FracturalVNE/core/visuals/single_visual.tscn")
	
	var instance = visual_prefab.instance()
	
	instance.init(load(serialized_obj["texture_path"]))
	instance.visible = serialized_obj["visible"]
	
	return instance

# ----- Serialization ----- #
