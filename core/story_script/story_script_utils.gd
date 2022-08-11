extends Reference
# General purpose class for StoryScript related things.
#
# These methods are often StoryScriptErrorable, meaning
# they will return a StoryScriptError when they hit an
# error. This allows for easy integration with Stories,
# since the game must break on error.


const FracUtils = preload("res://addons/FracturalVNE/core/utils/utils.gd")
const Error = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")


# -- StoryScriptErrorable -- #
# Evaluates object to a type. If the object is not
# the type then it attempts to cast it to the type.
static func evaluate_and_cast(object, type):
	var result = object.evaluate()
	if not is_success(result):
		return result
	var cast_result = FracUtils.implicit_cast(result, type)
	if cast_result == null:
		# Implicit cast failed
		return error("Cannot cast object \"%s\" (type \"%s\") to type \"%s\"." % [result, FracUtils.get_type_name(result), type])
	return cast_result


# Checks if a result is successful (meaning it is not a StoryScript.Error).
# This is used for error checking in StoryScript related scripts that must
# suspend execution when an error is encountered.
static func is_success(result) -> bool:
	return result == null or (not result is Error and not result is Error.ErrorStack)


# Shorthand for creating an error
static func error(message, position = null, confidence = 0):
	return Error.new(message, position, confidence)


# Stacks an error (message_or_error) onto an old_error and returns 
# the resulting ErrorStack.
static func stack_error(old_error, message_or_error):
	var new_error
	if message_or_error is String:
		new_error = error(message_or_error)
	elif message_or_error is Error:
		new_error = message_or_error
	else:
		 assert(false, "Unknown of stack_error()")
	
	if old_error is Error.ErrorStack:
		old_error.add_error(new_error)
		return old_error
	elif old_error is Error:
		var err_stack = Error.ErrorStack.new([old_error])
		err_stack.add_error(new_error)
		return err_stack
	else:
		assert(false, "Unknown of stack_error()")


# -- StoryScriptErrorable -- #
static func load(path):
	var result = ResourceLoader.load(path)
	if result == null:
		return Error.new("Could not load file at \"%s\"." % path)
	return result


# -- StoryScriptErrorable -- #
# Gets all the files in a directory. See get_dir_contents() for more information
# about the parameters for this method since they are the same for both methods.
static func get_dir_files(root_path: String, search_sub_directories: bool = true, file_extensions: Array = []):
	var result = get_dir_contents(root_path, search_sub_directories, file_extensions)
	if not is_success(result):
		return result
	return result[0]


# -- StoryScriptErrorable -- #
# Gets all the sub directories in a directory. See get_dir_contents() for more information
# about the parameters for this method since they are the same for both methods.
static func get_dir_sub_dirs(root_path: String, search_sub_directories: bool = true, file_extensions: Array = []):
	var result = get_dir_contents(root_path, search_sub_directories, file_extensions)
	if not is_success(result):
		return result
	return result[1]


# -- StoryScriptErrorable -- #
# Gets all the files in a directory. Searches all subdirectories as well by default.
#
# You can specify whether to search in sub directories
#
# You can optionally specify to look for only files of a specific extension
# by providing a String array for file_extensions that contains
# a string for each extension you want. Do not include a `.` in each
# extension string (ie. ".png" should be "png").
static func get_dir_contents(root_path: String, search_sub_directories: bool = true, file_extensions: Array = []):
	var files = []
	var directories = []
	var dir = Directory.new()

	var result = dir.open(root_path)
	if result == OK:
		dir.list_dir_begin(true, false)
		FracUtils._add_dir_contents(dir, files, directories, search_sub_directories, file_extensions)
	else:
		return Error.new("An error occurred when trying to access the path. Directory error: %s" % [result])

	return [files, directories]
