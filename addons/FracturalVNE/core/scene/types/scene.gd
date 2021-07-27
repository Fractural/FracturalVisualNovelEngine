extends Reference
# Base class for all scenes


# ----- Typeable ----- #

func is_type(type):
	return get_types().has(type)


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
