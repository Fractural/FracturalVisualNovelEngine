extends Reference
# A template file to create new StoryServices off of.


# ----- StoryService ----- #

# Optional
const FuncDef = FracVNE.StoryScript.FuncDef
const Param = FracVNE.StoryScript.Param

# Optional
var function_definitions = [
	FuncDef.new("function1_name", [
		Param.new("arg_name1"),
		Param.new("arg_name2", 0.1230),
		]),
	FuncDef.new("function2_name", [
		Param.new("arg_name1", "default"),
		Param.new("arg_name2", 0.1230),
		]),
	FuncDef.new("function3_name", [
		Param.new("arg_name1"),
	]),
]


# Optional
func configure_service(program_node):
	pass


func get_service_name():
	return "DemoService"

# ----- StoryService ----- #
