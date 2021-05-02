extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_parser.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("variable declaration")
	return arr

func get_keywords():
	return ["define"]

func get_punctuation():
	return ["="]

func parse(parser):
	var checkpoint = parser.save_checkpoint()
	var label = parser.expect_token("keyword", "define")
	if parser.is_success(label):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			var assignment_punc = parser.expect_token("punctuation", "=")
			if parser.is_success(assignment_punc):
				var expression = parser.expect("expression")
				if parser.is_success(expression):
					return VariableDeclarationNode.new(identifier.symbol, expression)
				else:
					return parser.error(expression, 3/4.0, checkpoint)
			else:
				return parser.error(assignment_punc, 2/4.0, checkpoint)
		else:
			return parser.error(identifier, 1/4.0, checkpoint)
	else:
		return parser.error(label, 0, checkpoint)

class VariableDeclarationNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var variable_name: String
	var value_expression
	
	func _init(variable_name_: String, value_expression_):
		variable_name = variable_name_
		value_expression = value_expression_
	
	func execute(runtime_manager):
		# TODO Add add_label
		runtime_manager.declare_variable(self)
	
	func debug_string(tabs_string: String):
		var string = ""
		string += tabs_string + "VAR DECLARE " + variable_name + " :" 
		string += "\n" + tabs_string + "{"
		string += "\n" + tabs_string + "VALUE: " + str(value_expression)
		string += "\n" + tabs_string + "}"
