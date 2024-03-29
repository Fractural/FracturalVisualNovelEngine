extends Node


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
	FuncDef.new("load", [
		Param.new("path"),
		])
]


func get_service_name():
	return "ResourceLoader"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils


func load(path):
	# Godot automatically caches resources when loading so memory
	# use will be efficient.
	var result = ResourceLoader.load(path)
	if result == null:
		return SSUtils.error("Could not load resource at path \"%s\"" % path)
	else:
		return result
