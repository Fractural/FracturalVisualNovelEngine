extends "res://addons/FracturalVNE/core/visuals/types/visual_controller.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisualController")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var sprite_path: NodePath

# Array of textures
var textures: Array
# Key: Modifiers (as string)
# Value: Corresponding texture
var textures_dict: Dictionary

onready var sprite = get_node(sprite_path)


func init(visual_, story_director_):
	.init(visual_, story_director_)
	
	sprite = get_node(sprite_path)
	
	var image_paths = SSUtils.get_dir_files(visual.textures_directory, true, ["png", "jpeg", "jpg", "bmp"])
	if not SSUtils.is_success(image_paths):
		return SSUtils.stack_error(image_paths, "Could not load the texture directory of \"%s\"." % visual.textures_directory)
	
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


func set_sprite(modifiers_string):
	if textures_dict.has(modifiers_string):
		sprite.texture = textures_dict[modifiers_string]
	else:
		return FracVNE.StoryScript.Error.new("Could not find the texture with the modifiers \"%s\" for this MultiVisual." % modifiers_string)


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
