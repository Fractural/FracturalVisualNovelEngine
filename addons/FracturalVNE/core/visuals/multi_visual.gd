extends "visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("MultiVisual")
	return arr

# ----- Typeable ----- #


# Array of textures
var textures: Array
# Key: Modifiers (as string)
# Value: Corresponding texture
var textures_dict: Dictionary


func _init(textures_ = null, name_ = null).(name_):
	textures = textures_


func _post_init():
	# Create the textures_dict to support fast lookup
	textures_dict = {}
	for texture in textures:
		# This does not support textures created at runtime since those
		# textures do not have a file path.
		textures_dict[_get_modifiers_string(texture.resource_path().get_basename().get_file())] = texture


func get_texture(modifiers_string):
	return textures_dict[modifiers_string]


func _get_modifiers_string(file_name: String) -> String:
	var modifiers: Array = file_name.replace("_", " ").to_lower().split(" ", false)
	
	var modifiers_string: String = ""
	# Skip the first entry in the file_name since that is the name of the character
	for i in range(1, modifiers.size() - 1):
		modifiers_string += modifiers[i]
	
	return modifiers_string
