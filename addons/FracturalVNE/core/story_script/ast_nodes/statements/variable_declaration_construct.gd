extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

const VariableDeclarationNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/variable_declaration.gd")

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
