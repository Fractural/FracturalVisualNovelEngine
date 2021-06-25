extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

const BlockNode = preload("res://addons/FracturalVNE/core/story_script/ast_nodes/misc/block_node.gd")

func get_parse_types() -> Array:
	return ["block"]

func get_keywords() -> Array:
	return ["block"]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var newline = parser.expect_token("punctuation", "newline")
	if parser.is_success(newline):
		var indent = parser.expect_token("punctuation", "indent")
		if parser.is_success(indent):
			var statements = []
			while not parser.is_success(parser.expect_token("punctuation", "dedent")):
				if parser.is_EOF():
					return parser.error("Expected dedent to close block but reached end of the file instead.", 1, checkpoint)
				var statement = parser.expect("statement")
				if not parser.is_success(statement):
					if statements.size() == 0:
						statement.message += " Expected at least one statement in a block."
					return parser.error(statement, 1, checkpoint)
				statements.append(statement)
			return BlockNode.new(indent.position, statements)
		else:
			indent.message = "Expected an indent to begin a block."
			return parser.error(indent, 1/2.0, checkpoint)
	else:
		newline.message = "Expected a newline to begin a block."
		return newline
# TODO NOW: Port over ast_nodes following the google drawings UML diagram
