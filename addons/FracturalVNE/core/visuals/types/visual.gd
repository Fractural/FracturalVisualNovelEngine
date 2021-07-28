extends Reference
# Responsible for holding data about visuals and also building them.
# Base class for all VisualBlueprints.


# ----- Typeable ----- #

static func is_type(type):
	return get_types().has(type)


static func get_types() -> Array:
	return ["Visual"]

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

var cached = false


func _init(cached_ = null):
	cached = cached_


func instantiate_controller(story_director):
	var instance = _get_visual_prefab().instance()
	var init_result = instance.init(self, story_director)
	if not SSUtils.is_success(init_result):
		return init_result
	return instance


func _get_visual_prefab():
	pass



# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"cached": cached,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.cached = serialized_object
	return instance

# ----- Serialization ----- #
