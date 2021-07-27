extends Node2D
# Base class for all scene controller


# ----- Typeable ----- #

func is_type(type):
	return get_types().has(type)


func get_types():
	return ["BGSceneController"]

# ----- Typeable ----- #


var scene


func init(scene_):
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
