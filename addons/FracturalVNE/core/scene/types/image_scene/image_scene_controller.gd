extends "res://addons/FracturalVNE/core/scene/types/scene_controller.gd"


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("ImageSceneController")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var sprite_path: NodePath

onready var sprite = get_node(sprite)


func init(scene_):
	.init(scene_)
	
	var texture_result = SSUtils.load(scene.texture_path)
	if not SSUtils.is_success(texture_result):
		return texture_result
	
	sprite.texture = texture_result


# ----- Serialization ----- #

# image_scene_controller_serializer.gd

# ----- Serialization ----- #
