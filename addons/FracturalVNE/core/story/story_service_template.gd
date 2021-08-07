extends Reference
# A template file to create new StoryServices off of.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptService", get_service_name(), "ASTVisitor"]

# ----- Typeable ----- #


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
# Configures a service for a new AST.
# (program_node is the root of the AST).
func configure_service(program_node):
	pass


func get_service_name():
	return "DemoService"

# ----- StoryService ----- #


# ----- Serialization ----- #

# Optional
func serialize_state() -> Dictionary:
	return {
		"service_name": get_service_name()
	}


func deserialize_state(serialized_state) -> void:
	pass

# ----- Serialization ----- #
