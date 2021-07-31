class_name FracVNE_BGScene, "res://addons/FracturalVNE/assets/icons/bg_scene.svg"
extends Resource
# Base class for all scenes


# ----- Typeable ----- #

func get_types():
	return ["BGScene"]

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils


var controller_prefab


func instantiate_controller():
	var instance = controller_prefab.instance()
	var init_result = instance.init(self)
	if not SSUtils.is_success(init_result):
		return init_result
	return instance
