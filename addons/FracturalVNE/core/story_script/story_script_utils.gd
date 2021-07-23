extends Reference

const Error = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")


static func is_success(result) -> bool:
	return result == null or (not result is Error and not result is Error.ErrorStack)


static func load(path):
	var result = ResourceLoader.load(path)
	if result == null:
		return Error.new("Could not load file at \"%s\"." % path)
	return result


# Gets all the files in a directory. Searches all subdirectories as well by default.
#
# You can specify whether to search in sub directories
#
# You can optionally specify to look for only files of a specific extension
# by providing a String array for file_extensions that contains
# a string for each extension you want. Do not include a `.` in each
# extension string (ie. ".png" should be "png").
static func get_dir_contents(rootPath: String, search_sub_directories: bool = true, file_extensions = null):
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open(rootPath) == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories, search_sub_directories, file_extensions)
	else:
		return Error.new("An error occurred when trying to access the path.")

	return [files, directories]


# Helper method for get_dir_contents()
static func _add_dir_contents(dir: Directory, files: Array, directories: Array, search_sub_directories: bool = true, file_extensions = null):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
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
					# print("Found file: %s" % path)
					files.append(path)
					break

		file_name = dir.get_next()

	dir.list_dir_end()
