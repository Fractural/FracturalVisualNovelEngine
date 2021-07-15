class_name FracturalUtils
extends Reference
# TODO: Make FracturalUtils into a Fractural namespace with
#		containing specific util classes as constant variables.
#		Basically we want to split FracturalUtils into smaller
#		and more specific utils classes to ensure that the
#		Single Responsibility Principle holds.


# define a constant that maps the type ID to the string for it's name.
# we won't need to include TYPE_OBJECT since we will handle it differently.
const TYPE_STR_MAPPING = {
	TYPE_NIL: "Null",
	TYPE_INT: "int",
	TYPE_REAL: "float",
	TYPE_STRING: "String",
}


# Declare a function to determine the name of the type.
# Because we need nothing but the constant and the parameter,
# we do not need state information, so we should make this a static function.
static func get_type_name(p_value):
	# check the type of the value given to us
	match typeof(p_value):
		# If it's an Object, return Object.get_class().
		# Will work for Node, Resource, etc.
		TYPE_OBJECT:
			return p_value.get_class()
		# For every other type, return our custom mapped string.
		_:
			return TYPE_STR_MAPPING[typeof(p_value)]


# Snakecase conversions source:
# https://gist.github.com/me2beats/443b40ba79d5b589a96a16c565952419

static func snake2camel(string: String) -> String:
	var result = PoolStringArray()
	var prev_is_underscore = false
	for ch in string:
		if ch=='_':
			prev_is_underscore = true
		else:
			if prev_is_underscore:
				result.append(ch.to_upper())
			else:
				result.append(ch)
			prev_is_underscore = false


	return result.join('')


static func snake2pascal(string: String) -> String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result


static func camel2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())

	return result.join('')


static func pascal2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')


# Gets all the files in a directory. Searches all subdirectories as well by default.
#
# You can specify whether to search in sub directories
#
# You can optionally specify to look for only files of a specific extension
# by providing a String array for file_extensions that contains
# a string for each extension you want. Do not include a `.` in each
# extension string (ie. ".png" should be "png").
static func get_dir_contents(rootPath: String, search_sub_directories: bool = true, file_extensions = null) -> Array:
    var files = []
    var directories = []
    var dir = Directory.new()

    if dir.open(rootPath) == OK:
        dir.list_dir_begin(true, false)
        _add_dir_contents(dir, files, directories, search_sub_directories, file_extensions)
    else:
        push_error("An error occurred when trying to access the path.")

    return [files, directories]


# Helper method for get_dir_contents()
static func _add_dir_contents(dir: Directory, files: Array, directories: Array, search_sub_directories: bool = true, file_extensions = null):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: %s" % path)
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			directories.append(path)
			
			if search_sub_directories:
				_add_dir_contents(subDir, files, directories)
		else:
			# TODO: Maybe convert file_extensions to a hashtable if performance is necessary?
			for file_extension in file_extensions:
				if file_extension == path.get_extension():
					print("Found file: %s" % path)
					files.append(path)
					break

		file_name = dir.get_next()

	dir.list_dir_end()


static func is_in_editor_scene_tab(node):
	if Engine.is_editor_hint():
		# Only tested so far to work on Godot 3.3
		if node == null:
			return false
		elif node.name == "@@5903":
			return true
		return is_in_editor_scene_tab(node.get_parent())
	return false
