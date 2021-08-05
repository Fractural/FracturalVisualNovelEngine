extends Node
# Holds general purpose functions that don't need their own story service.


# ----- StoryService ----- #

const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

var function_definitions = [
	FuncDef.new("Point", [
		Param.new("x"),
		Param.new("y"),
		]),
]


func get_service_name():
	return "GeneralFunctions"

# ----- StoryService ----- #


func Point(x, y):
	return Vector2(x, y)
