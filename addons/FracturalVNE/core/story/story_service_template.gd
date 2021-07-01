extends Reference
# A template file to create new StoryServices off of.


# ----- StoryService ----- #

# Optional
var function_definitions = [
	StoryScriptFuncDef.new("function1_name", [
		StoryScriptParameter.new("arg_name1"),
		StoryScriptParameter.new("arg_name2", 0.1230),
		]),
	StoryScriptFuncDef.new("function2_name", [
		StoryScriptParameter.new("arg_name1", "default"),
		StoryScriptParameter.new("arg_name2", 0.1230),
		]),
	StoryScriptFuncDef.new("function3_name", [
		StoryScriptParameter.new("arg_name1"),
	]),
]


# Optional
func configure_service(program_node):
	pass


func get_service_name():
	return "DemoService"

# ----- StoryService ----- #
