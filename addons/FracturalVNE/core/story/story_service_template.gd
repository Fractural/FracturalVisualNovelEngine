extends Reference
# A template file to create new StoryServices off of.


# ----- StoryService ----- #

# Optional
var function_definitions = [
	FracVNE.StoryScript.FuncDef.new("function1_name", [
		FracVNE.StoryScript.Param.new("arg_name1"),
		FracVNE.StoryScript.Param.new("arg_name2", 0.1230),
		]),
	FracVNE.StoryScript.FuncDef.new("function2_name", [
		FracVNE.StoryScript.Param.new("arg_name1", "default"),
		FracVNE.StoryScript.Param.new("arg_name2", 0.1230),
		]),
	FracVNE.StoryScript.FuncDef.new("function3_name", [
		FracVNE.StoryScript.Param.new("arg_name1"),
	]),
]


# Optional
func configure_service(program_node):
	pass


func get_service_name():
	return "DemoService"

# ----- StoryService ----- #
