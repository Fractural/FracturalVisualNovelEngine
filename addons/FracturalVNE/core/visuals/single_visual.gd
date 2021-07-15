extends "visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


export var sprite_path: NodePath

onready var sprite = get_node(sprite_path)

var texture: Texture


func init(texture_):
	texture = texture_
	sprite.texture = texture


# ----- Serialization ----- #

func serialize():	
	return {
		"script_path": get_script().get_path(),
		"texture_path": texture.get_path(),
	}


func deserialize(serialized_object):
	var visual_prefab = load("single_visual.tscn")
	
	var instance = visual_prefab.instance()
	
	instance.init(load(serialized_object["texture_path"]))
	
	return instance

# ----- Serialization ----- #
