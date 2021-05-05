extends "res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/value_component_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("function call")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var function = parser.expect_token("identifier")
	if parser.is_success(function):
		var arguments = parser.expect("parenthesized arguments")
		if parser.is_success(arguments):
			return FunctionCallNode.new(function.position, function.symbol, arguments)
		else:
			return parser.error(arguments, arguments.confidence, checkpoint)
	else:
		return function

class FunctionCallNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	static func get_types() -> Array:
		var arr = .get_types()
		arr.append("function call")
		return arr
	
	static func is_stepped() -> bool:
		return false
	
	var name: String
	var argument_group
	
	func _init(position_, name_: String, argument_group_).(position_):
		name = name_
		argument_group = argument_group_
	
	func execute():
		# Formatted arguments is in the form of:
		# [["parameter name", value]. ["another param name", another_value]]
		var formatted_arguments = []
		for argument in argument_group.arguments:
			var evaluated_value = argument.value.evaluate()
			if is_success(evaluated_value):
				formatted_arguments.append([argument.name, evaluated_value])
			else:
				throw_error(evaluated_value)
		
		var result = runtime_block.call_function(name, formatted_arguments)
		if is_success(result):
			.execute()
		else:
			throw_error(stack_error(result, 'Error calling function "%s".' % name))
		
	func debug_string(tabs_strings) -> String:
		var string = ""
		string += tabs_strings + "CALL FUNC " + name + ":"
		string += "\n" + tabs_strings + "{"
		string += "\n" + argument_group.debug_string(tabs_strings + "\t")
		string += "\n" + tabs_strings + "}"
		return string
