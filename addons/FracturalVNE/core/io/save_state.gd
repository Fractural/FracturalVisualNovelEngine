extends Reference

var starting_node_id
var story_save_nodes
var story_file_path
var saved_date
var screenshot

# TODO: Add screenshots to save_state

func _init(story_file_path_ = null, starting_node_id_ = null, story_save_nodes_ = null, screenshot_ = null):
	story_file_path = story_file_path_
	starting_node_id = starting_node_id_
	story_save_nodes = story_save_nodes_
	screenshot = screenshot_
	saved_date = OS.get_datetime()

# ----- Serialization ----- #

func serialize():
	# Screenshot serialization start
	
	var screenshot_image = screenshot.get_data()
	
	var array : PoolByteArray = screenshot_image.get_data()
	var sg_width = screenshot_image.get_width()
	var sg_height = screenshot_image.get_height()
	var sg_format = screenshot_image.get_format()
	var sg_mipmap = screenshot_image.has_mipmaps()
	var sg_u_size = array.size()
	array = array.compress(File.COMPRESSION_DEFLATE)
	var sg_saved_img = Marshalls.raw_to_base64(array)
	
	var screenshot_data = {"image" : sg_saved_img, "size" : sg_u_size, "width" : sg_width, "height" : sg_height, "mipmap" : sg_mipmap, "format" : sg_format}
	
	# Screenshot serialization end
	
	return {
		"script_path": "res://addons/FracturalVNE/core/io/save_state.gd",
		"story_file_path": story_file_path,
		"starting_node_id": starting_node_id,
		"story_save_nodes": story_save_nodes,
		"saved_date": saved_date,
		"screenshot": screenshot_data,
	}

func deserialize(serialized_obj):
	var instance = get_script().new()
	instance.story_file_path = serialized_obj["story_file_path"]
	instance.starting_node_id = serialized_obj["starting_node_id"]
	instance.story_save_nodes = serialized_obj["story_save_nodes"]
	instance.saved_date = serialized_obj["saved_date"]
	
	# Screenshot deserialization start
	
	var t_image = serialized_obj["screenshot"]["image"]
	var t_size = serialized_obj["screenshot"]["size"]
	var t_width = serialized_obj["screenshot"]["width"]
	var t_height = serialized_obj["screenshot"]["height"]
	var t_mipmap = serialized_obj["screenshot"]["mipmap"]
	var t_format = serialized_obj["screenshot"]["format"]

	var array = Marshalls.base64_to_raw(t_image)
	array = array.decompress(t_size, File.COMPRESSION_DEFLATE)
	
	var img = Image.new()
	img.create_from_data(t_width, t_height, t_mipmap, t_format, array)
	
	var screenshot_texture = ImageTexture.new()
	screenshot_texture.create_from_image(img)
	
	instance.screenshot = screenshot_texture
	
	# Screenshot deserialization end	
	
	return instance

func _to_string():
	return "SAVE STATE: [ID: %s, NODES: %s, FILEPATH: %s, DATE: %s]" % [str(starting_node_id), str(story_save_nodes), str(story_file_path), str(saved_date)]

# ----- Serialization ----- #
