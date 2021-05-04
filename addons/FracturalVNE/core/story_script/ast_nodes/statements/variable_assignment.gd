extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("variable assignment")
	return arr

func get_punctuation():
	return ["="]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var identifier = parser.expect_token("identifier")
	if parser.is_success(identifier):
		var assignment_punc = parser.expect_token("punctuation", "=")
		if parser.is_success(assignment_punc):
			var expression = parser.expect("expression")
			if parser.is_success(expression):
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return VariableAssignmentNode.new(identifier.position, identifier.symbol, expression)
				else:
					return parser.error("Expected a new line to conclude a statement.", 1, checkpoint)
			else:
				return parser.error(expression, 2/3.0, checkpoint)
		else:
			return parser.error(assignment_punc, 1/3.0, checkpoint)
	else:
		return parser.error(identifier, 0, checkpoint)

class VariableAssignmentNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd":
	static func get_types() -> Array:
		var arr = .get_types()
		arr.append("variable assignment")
		return arr
	
	var variable_name: String
	var value_expression
	
	func _init(position_, variable_name_: String, value_expression_).(position_):
		variable_name = variable_name_
		value_expression = value_expression_
	
	func execute():
		var result = value_expression.evaluate()
		if not is_success(result):
			throw_error(result)
			return
		
		runtime_block.get_variable(variable_name).value = result
		.execute()
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "VAR ASSIGN " + variable_name + ":" 
		string += "\n" + tabs_string + "{"
		string += "\n" + tabs_string + "\tNEW VALUE:"
		string += "\n" + tabs_string + "\t{"
		string += "\n" + value_expression.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"
		string += "\n" + tabs_string + "}"
		return string
