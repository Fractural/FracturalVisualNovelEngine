extends "res://addons/FracturalVNE/core/actor/control_actor_controller.gd"
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

func serialize():
	return {
		"script_path": get_script().get_path(),
		"visible": visible,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.visible = serialized_object["visible"]
	return instance

# ----- Serialization ----- #
