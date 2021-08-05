extends "res://addons/FracturalVNE/core/visuals/types/visual_controller.gd"


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisualController")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils
const FracUtils = FracVNE.Utils

export var sprite_path: NodePath
export var old_sprite_path: NodePath

# Array of textures
var textures: Array
# Key: Modifiers (as string)
# Value: Corresponding texture
var textures_dict: Dictionary

onready var sprite = get_node(sprite_path)
onready var old_sprite = get_node(old_sprite_path)


func init(visual_ = null, story_director_ = null):
	.init(visual_, story_director_)
	
	var image_paths
	var image_extensions = ["png", "jpeg", "jpg", "bmp"]
	
	image_paths = SSUtils.get_dir_files(get_visual().textures_directory, true, image_extensions)
	
	if not SSUtils.is_success(image_paths):
		return SSUtils.stack_error(image_paths, "Could not load the texture directory of \"%s\"." % get_visual().textures_directory)
	
	textures = []
	for path in image_paths:
		var texture_result = SSUtils.load(path)
		if not SSUtils.is_success(texture_result):
			return texture_result
		textures.append(texture_result)
	
	# Since MultiVisualController is a node, we can operate on it's variables after
	# setting them in init() since init() will only be called when the
	# node is instantiated for real and not just to use the deserialize()
	# function (Which is called by SerializationUtils as a general way to
	# to deserialize all serializable objects).
	
	# Create the textures_dict to support fast lookup
	textures_dict = {}
	for texture in textures:
		# This does not support textures created at runtime since those
		# textures do not have a file path.
		var resource_path = texture.get_path().get_basename().get_file()
		var mod_str = _get_modifiers_string(texture.get_path().get_basename().get_file())
		textures_dict[_get_modifiers_string(texture.get_path().get_basename().get_file())] = texture


func set_sprite_show(modifiers_string, standard_transition: FracVNE_StandardNode2DTransition = null):
	if textures_dict.has(modifiers_string):
		old_sprite.texture = sprite.texture
		sprite.texture = textures_dict[modifiers_string]
		
		# ----- Optional Transitioning ----- #
		
		var result
		if visible and old_sprite.texture != null and old_sprite.texture != sprite.texture:
			# Perform a replace transition if we are visible
			# and we have a new and different texture.
			result = get_actor_transitioner().replace(standard_transition)
		else:
			# Default to show transition.
			result = get_actor_transitioner().show(standard_transition)
		if not SSUtils.is_success(result):
			return result
		
		# ----- Optional Transitioning ----- #
	else:
		return SSUtils.error("Could not find the texture with the modifiers \"%s\" for this MultiVisual." % modifiers_string)


func _get_modifiers_string(file_name: String) -> String:
	var modifiers: Array = file_name.replace("_", " ").to_lower().split(" ", false)
	
	var modifiers_string: String = ""
	# Skip the first entry in the file_name since that is the name of the character
	for i in range(1, modifiers.size()):
		modifiers_string += modifiers[i]
	
	return modifiers_string


# ----- Serialization ----- #

# multi_visual_serializer.gd

# ----- Serialization ----- #
