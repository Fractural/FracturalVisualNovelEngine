extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

const LabelNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/statements/label_statement.gd")

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("label")
	return arr

func get_keywords() -> Array:
	return ["label"]

func get_punctuation() -> Array:
	return [":"]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var label = parser.expect_token("keyword", "label")
	if parser.is_success(label):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			var colon = parser.expect_token("punctuation", ":")
			if parser.is_success(colon):
				var block = parser.expect("block")
				if parser.is_success(block):
					return LabelNode.new(label.position, identifier.symbol, block)
				else:
					return parser.error(block, 4/5.0, checkpoint)
			else:
				var params = parser.expect("parenthesized parameters")
				if parser.is_success(params):
					colon = parser.expect_token("punctuation", ":")
					if parser.is_success(colon):
						var block = parser.expect("block")
						if parser.is_success(block):
							return LabelNode.new(label.position, identifier.symbol, block, params)
						else:
							return parser.error(block, 4/5.0, checkpoint)
					else:
						return parser.error(colon, 3/5.0, checkpoint)
				else:
					return parser.error(params, 2/5.0, checkpoint)
		else:
			return parser.error(identifier, 1/5.0, checkpoint)
	else:
		return parser.error(label, 0)
# TODO NOW: Port over ast_nodes following the google drawings UML diagram
