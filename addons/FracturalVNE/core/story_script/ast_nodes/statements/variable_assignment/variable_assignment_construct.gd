extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"


const VariableAssignmentNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_assignment/variable_assignment.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("VariableAssignmentStatement")
	return arr


func get_punctuation():
	return ["="]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	var identifier = parser.expect_token("identifier")
	if parser.is_success(identifier):
		var assignment_punc = parser.expect_token("punctuation", "=")
		if parser.is_success(assignment_punc):
			var expression = parser.expect("Expression")
			if parser.is_success(expression):
				if parser.is_success(parser.expect_token("punctuation", "newline")):
					return VariableAssignmentNode.new(identifier.position, identifier.symbol, expression)
				else:
					return parser.error("Expected a new line to conclude a statement.", 3/4.0, checkpoint)
			else:
				return parser.error(expression, 2/4.0, checkpoint)
		else:
			return parser.error(assignment_punc, 1/4.0, checkpoint)
	else:
		return parser.error(identifier, 0, checkpoint)
