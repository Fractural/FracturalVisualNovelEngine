extends Reference
# Stores a saved state of the story.


var starting_node_id
var story_tree_state
var story_file_path
var saved_date
var thumbnail


func _init(story_file_path_ = null, starting_node_id_ = null, story_tree_state_ = null, thumbnail_ = null):
	story_file_path = story_file_path_
	starting_node_id = starting_node_id_
	story_tree_state = story_tree_state_
	thumbnail = thumbnail_
	saved_date = OS.get_datetime()


# ----- Serialization ----- #

func serialize() -> Dictionary:
	# ----- Thumbnail Serialization ----- #
	
	var thumbnail_image = thumbnail.get_data()
	
	var array : PoolByteArray = thumbnail_image.get_data()
	var sg_width = thumbnail_image.get_width()
	var sg_height = thumbnail_image.get_height()
	var sg_format = thumbnail_image.get_format()
	var sg_mipmap = thumbnail_image.has_mipmaps()
	var sg_u_size = array.size()
	array = array.compress(File.COMPRESSION_DEFLATE)
	var sg_saved_img = Marshalls.raw_to_base64(array)
	
	var thumbnail_data = {"image" : sg_saved_img, "size" : sg_u_size, "width" : sg_width, "height" : sg_height, "mipmap" : sg_mipmap, "format" : sg_format}
	
	# ----- Thumbnail Serialization ----- #
	
	return {
		"script_path": "res://addons/FracturalVNE/core/io/save_state.gd",
		"story_file_path": story_file_path,
		"starting_node_id": starting_node_id,
		"story_tree_state": story_tree_state,
		"saved_date": saved_date,
		"thumbnail": thumbnail_data,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.story_file_path = serialized_object["story_file_path"]
	instance.starting_node_id = serialized_object["starting_node_id"]
	instance.story_tree_state = serialized_object["story_tree_state"]
	instance.saved_date = serialized_object["saved_date"]
	
	# ----- Thumbnail Deserialization ----- #
	
	var t_image = serialized_object["thumbnail"]["image"]
	var t_size = serialized_object["thumbnail"]["size"]
	var t_width = serialized_object["thumbnail"]["width"]
	var t_height = serialized_object["thumbnail"]["height"]
	var t_mipmap = serialized_object["thumbnail"]["mipmap"]
	var t_format = serialized_object["thumbnail"]["format"]

	var array = Marshalls.base64_to_raw(t_image)
	array = array.decompress(t_size, File.COMPRESSION_DEFLATE)
	
	var img = Image.new()
	img.create_from_data(t_width, t_height, t_mipmap, t_format, array)
	
	var thumbnail_texture = ImageTexture.new()
	thumbnail_texture.create_from_image(img)
	
	instance.thumbnail = thumbnail_texture
	
	# ----- Thumbnail Deserialization ----- #
	
	return instance

func _to_string():
	return "SAVE STATE: [ID: %s, TREE_STATE: %s, FILEPATH: %s, DATE: %s]" % [str(starting_node_id), str(story_tree_state), str(story_file_path), str(saved_date)]

# ----- Serialization ----- #
