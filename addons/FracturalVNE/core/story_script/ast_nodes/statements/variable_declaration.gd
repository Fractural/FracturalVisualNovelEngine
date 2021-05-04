extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("variable declaration")
	return arr

func get_keywords():
	return ["define"]

func get_punctuation():
	return ["="]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var label = parser.expect_token("keyword", "define")
	if parser.is_success(label):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			var assignment_punc = parser.expect_token("punctuation", "=")
			if parser.is_success(assignment_punc):
				var expression = parser.expect("expression")
				if parser.is_success(expression):
					if parser.is_success(parser.expect_token("punctuation", "newline")):
						return VariableDeclarationNode.new(identifier.position, identifier.symbol, expression)
					else:
						return parser.error("Expected a new line to conclude a statement.", 4/5.0, checkpoint)
				else:
					return parser.error(expression, 3/5.0, checkpoint)
			else:
				return parser.error(assignment_punc, 2/5.0, checkpoint)
		else:
			return parser.error(identifier, 1/5.0, checkpoint)
	else:
		return parser.error(label, 0, checkpoint)

class VariableDeclarationNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statement_node.gd":
	static func get_types() -> Array:
		var arr = .get_types()
		arr.append("variable declaration")
		return arr
	
	var variable_name: String
	var value_expression
	
	func _init(position_, variable_name_: String, value_expression_).(position_):
		variable_name = variable_name_
		value_expression = value_expression_
	
	func execute():
		runtime_block.declare_variable(variable_name, value_expression)
		.execute()
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "VAR DECLARE " + variable_name + ":" 
		string += "\n" + tabs_string + "{"
		string += "\n" + tabs_string + "\tVALUE:"
		string += "\n" + tabs_string + "\t{"
		string += "\n" + value_expression.debug_string(tabs_string + "\t\t")
		string += "\n" + tabs_string + "\t}"
		string += "\n" + tabs_string + "}"
		return string
