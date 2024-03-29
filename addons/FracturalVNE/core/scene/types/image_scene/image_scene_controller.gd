extends "res://addons/FracturalVNE/core/scene/types/scene_controller.gd"
# Scene that holds an image.


# ----- Typeable ----- #

func get_types():
	var arr = .get_types()
	arr.append("ImageSceneController")
	return arr

# ----- Typeable ----- #


export var texture_rect_path: NodePath

onready var texture_rect = get_node(texture_rect_path)


func init(scene_ = null, story_director_ = null):
	.init(scene_, story_director_)
	
	texture_rect = get_node(texture_rect_path)
	
	texture_rect.texture = scene.texture


# ----- Serialization ----- #

# image_scene_controller_serializer.gd

# ----- Serialization ----- #
