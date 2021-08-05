extends "res://addons/FracturalVNE/core/actor/actor_controller.gd"
# -- Abstract Class -- #
# Base class for all SceneControllers.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("BGSceneController")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

var scene


func init(scene_ = null, story_director_ = null):
	.init(scene_, story_director_)
	scene = scene_


func show():
	visible = true


func hide():
	visible = false


# ----- Serialization ----- #

# scene_controller_serializer.gd

# ----- Serialization ----- #
