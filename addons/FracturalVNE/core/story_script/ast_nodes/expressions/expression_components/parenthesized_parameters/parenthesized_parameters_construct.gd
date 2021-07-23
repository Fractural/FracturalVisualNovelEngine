extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node/node_construct.gd"

const ParameterGroupNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/expressions/expression_components/parenthesized_parameters/parameter_group.gd")

func get_punctuation():
	return ["(", ",", ")"]

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("parenthesized parameters")
	return arr

func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var parameters = {}
	
	var ahead = str(parser.peek().symbol) + str(parser.peek(2).symbol) + str(parser.peek(3).symbol)
	
	var open_paren = parser.expect_token("punctuation", "(")
	if parser.is_success(open_paren):
		if parser.is_success(parser.expect_token("punctuation", ")")):
			pass
		else:
			while true:
				if parser.is_EOF():
					return parser.error('Expected a ")" to close a parenthesized parameter group but reached the end of the file.', 1, checkpoint)
				
				var arg_name = null
				
				var param_identifier = parser.expect_token("identifier")
				if parser.is_success(param_identifier):
					if parameters.has(param_identifier.symbol):
						return parser.error('Parameter with the name "%s" already exists.' % param_identifier.symbol, 1, checkpoint)
					if parser.is_success(parser.expect_token("punctuation", "=")):
						var constant_expression = parser.expect("constant expression")
						if parser.is_success(constant_expression):
							var evaluated_expression = constant_expression.evaluate()
							if parser.is_success(evaluated_expression):
								parameters[param_identifier.symbol] = FracVNE.StoryScript.Param.new(param_identifier.symbol, evaluated_expression)
							else:
								return parser.error(evaluated_expression, 1, checkpoint)
						else:
							return parser.error("Expected an expression that does not contain variables or function calls.", 1, checkpoint)
					else:
						parameters[param_identifier.symbol] = FracVNE.StoryScript.Param.new(param_identifier.symbol)
				else:
					return parser.error(param_identifier, 1, checkpoint)
				
				if parser.is_success(parser.expect_token("punctuation", ",")):
					pass
				elif parser.is_success(parser.expect_token("punctuation", ")")):
					break
				else:
					return parser.error('Expected a "," or a ")" after a parameter.', 1, checkpoint)
		return ParameterGroupNode.new(open_paren.position, parameters.values())
	else:
		return open_paren
