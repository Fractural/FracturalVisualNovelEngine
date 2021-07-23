extends Node
# Holds general purpose functions that don't need their own story service.


# ----- StoryService ----- #

var function_definitions = [
	FracVNE.StoryScript.FuncDef.new("Point", [
		FracVNE.StoryScript.Param.new("x"),
		FracVNE.StoryScript.Param.new("y"),
		]),
]


func get_service_name():
	return "GeneralFunctions"

# ----- StoryService ----- #


func Point(x, y):
	return Vector2(x, y)
