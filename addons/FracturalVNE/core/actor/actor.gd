extends Resource
# -- Abstract Class -- #
# Responsible for holding data about actors and also building them.
# Base class for all ActorControllers


# ----- Typeable ----- #

func get_types() -> Array:
	return ["Actor", "Serializable"]

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var cached: bool = false


func _init(cached_ = false):
	cached = cached_


func instantiate_controller(story_director):
	# TODO: Maybe refactor to call init after ready?
	# 		Feels kinda like an inconvenience to have to manually
	# 		assign node paths again in init because ready
	# 		wasn't called... :/
	var instance = _get_controller_prefab().instance()
	var init_result = instance.init(self, story_director)
	if not SSUtils.is_success(init_result):
		return init_result
	
	return instance


func _get_controller_prefab():
	pass


# ----- Serialization ----- #

func serialize() -> Dictionary:
	return {
		"script_path": get_script().get_path(),
		"cached": cached,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.cached = serialized_object["cached"]
	return instance

# ----- Serialization ----- #
