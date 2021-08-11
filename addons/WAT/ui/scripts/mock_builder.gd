extends Reference
# Builds a mock for a GDscript class file.
# Note that this does not work for inner classes.
# This builder also assumes file names are written in snake case.


var original_directory: String
var tests_directory: String


func _init(original_directory_: String = "res://game", tests_directory_: String = "res://tests"):
	original_directory = original_directory_
	tests_directory = tests_directory_


func copy_original_directory():
	# Note that this will not attempt to delete already existing directories -- that is up to
	# the user to sort out if they decide to move directories.
	var sub_dirs = get_dir_sub_dirs(original_directory, true)
	var dir = Directory.new()
	for dir_path in sub_dirs:
		var tests_dir_path = dir_path.replace(original_directory, tests_directory)
		if not dir.dir_exists(tests_dir_path):
			dir.make_dir(tests_dir_path)


func build_all_mocks(target_directory: String = original_directory):
	copy_original_directory()
	var file_paths = get_dir_files(target_directory, true, ["gd"])
	for file_path in file_paths:
		var loaded_file = ResourceLoader.load(file_path)
		if loaded_file != null:
			# We successfully loaded the file
			build_mock(loaded_file)


func build_mock(script: Script, base_type: String = "Reference"):
	var mock_path = script.get_path().replace(original_directory, tests_directory).replace(".gd", ".mock.gd")
	var mock_class_name = snake2pascal(script.get_path().get_file().trim_suffix(".gd"))
	
	var mock_file = File.new()
	mock_file.open(mock_path, File.WRITE)
	
	# Extends
	mock_file.store_line("extends " + base_type)
	# Comments
	mock_file.store_line("# A mock class for %s." % mock_class_name)
	mock_file.store_string("\n\n")
	
	var method_list = _remove_duplicate_methods(script.get_script_method_list())
	for i in method_list.size():
		var method = method_list[i]
		var args_string = _generate_arguments_string(method)
		var return_variable_name = "_return_%s" % method.name
		var called_signal_name = "_called_%s" % method.name
		
		# Called signal
		mock_file.store_line("signal %s(%s)" % [called_signal_name, args_string])
		
		# Return variables
		mock_file.store_line("var %s" % return_variable_name)
		
		# Function declaration
		mock_file.store_line("func %s(%s):" % [method.name, args_string])
		
		# Emitting called signal
		if method.args.size() > 0:
			mock_file.store_line("\temit_signal(\"%s\", %s)" % [called_signal_name, args_string])
		else:
			mock_file.store_line("\temit_signal(\"%s\")" % called_signal_name)
		
		# Returning custom value
		mock_file.store_line("\treturn %s" % return_variable_name)
		
		# Spacing
		if i < method_list.size() - 1:
			mock_file.store_string("\n\n")
		else:
			mock_file.store_string("\n")

	mock_file.close()


func _remove_duplicate_methods(methods):
	var dict = {}
	for method in methods: 
		dict[method.name] = method
	return dict.values()

# Generates a string of arguments delimited by ', '.
func _generate_arguments_string(method):
	var arguments_string = ""
	for j in method.args.size():
		var argument = method.args[j]
		if argument.name != "":
			arguments_string += ""
		else:
			arguments_string += "arg_" + str(j)
		if j < method.args.size() - 1:
			arguments_string += ", "
	return arguments_string


# ----- Helpers ----- #

# Gets all the files in a directory. See get_dir_contents() for more information
# about the parameters for this method since they are the same for both methods.
static func get_dir_files(root_path: String, search_sub_directories: bool = true, file_extensions = null):
	var result = get_dir_contents(root_path, search_sub_directories, file_extensions)
	if not result:
		return []
	return result[0]


# Gets all the sub directories in a directory. See get_dir_contents() for more information
# about the parameters for this method since they are the same for both methods.
static func get_dir_sub_dirs(root_path: String, search_sub_directories: bool = true):
	var result = get_dir_contents(root_path, search_sub_directories, null)
	if not result:
		return []
	return result[1]


# Gets all the files in a directory. Searches all subdirectories as well by default.
#
# You can specify whether to search in sub directories
#
# You can optionally specify to look for only files of a specific extension
# by providing a String array for file_extensions that contains
# a string for each extension you want. Do not include a `.` in each
# extension string (ie. ".png" should be "png").
static func get_dir_contents(root_path: String, search_sub_directories: bool = true, file_extensions = null):
	var files = []
	var directories = []
	var dir = Directory.new()

	if dir.open(root_path) == OK:
		dir.list_dir_begin(true, false)
		_add_dir_contents(dir, files, directories, search_sub_directories, file_extensions)
	else:
		return false

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
				_add_dir_contents(subDir, files, directories, search_sub_directories, file_extensions)
		else:
			if file_extensions == null:
				files.append(path)
			else:
				# TODO DISCUSS: Maybe convert file_extensions to a hashtable if performance is necessary?
				for file_extension in file_extensions:
					if not Engine.is_editor_hint():
						# Only .import files are available in the exported builds,
						# therefore we have to look for those instead.
						path = path.trim_suffix(".import")
					if file_extension == path.get_extension():
						# print("Found file: %s" % path)
						if not files.has(path):
							files.append(path)
						break

		file_name = dir.get_next()

	dir.list_dir_end()


# Snakecase conversions sou/rce:
# https://gist.github.com/me2beats/443b40ba79d5b589a96a16c565952419

# Converts a string from snake-case to camel-case.
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


# Converts a string from snake-case to pascal-case.
static func snake2pascal(string: String) -> String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result


# Converts a string from camel-case to snake-case.
static func camel2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())

	return result.join('')


# Converts a string from pascal-case to snake-case.
static func pascal2snake(string: String) -> String:
	var result = PoolStringArray()
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	result[0] = result[0][1]
	return result.join('')

# ----- Helpers ----- #
