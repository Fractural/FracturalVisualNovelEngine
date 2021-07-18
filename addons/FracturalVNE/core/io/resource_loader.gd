extends Node


# ----- StoryService ----- #

# Optional
var function_definitions = [
	StoryScriptFuncDef.new("load", [
		StoryScriptParameter.new("path"),
		])
]


func get_service_name():
	return "ResourceLoader"

# ----- StoryService ----- #


func load(path):
	# Godot automatically caches resources when loading so memory
	# use will be efficient.
	var result = ResourceLoader.load(path)
	if result == null:
		return StoryScriptError.new("Could not load resource at path \"%s\"" % path)
	else:
		return result
