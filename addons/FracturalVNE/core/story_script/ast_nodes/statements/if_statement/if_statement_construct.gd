extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_construct.gd"
# Parses an IfStatement.


const IfStatement = preload("if_statement.gd")
const ElseStatement = preload("else_statement.gd")


func get_parse_types():
	var arr = .get_parse_types()
	arr.append("IfStatement")
	return arr


func get_keywords() -> Array:
	return ["if", "elif", "else"]


func parse(parser):
	var checkpoint = parser.save_reader_state()
	
	var if_statement = _parse_if(parser)
	if not parser.is_success(if_statement):
		return parser.error(if_statement, if_statement.confidence, checkpoint)
	
	var prev_if_statement = if_statement
	var elif_statement = _parse_elif(parser)
	while true:
		if not parser.is_success(elif_statement):
			if elif_statement.confidence == 1:
				return parser.error(elif_statement, elif_statement.confidence, checkpoint)
			break
		prev_if_statement.next_if_statement = elif_statement
		prev_if_statement = elif_statement
		elif_statement = _parse_elif(parser)
	
	var else_statement = _parse_else(parser)
	if parser.is_success(else_statement):
		prev_if_statement.next_if_statement = else_statement
	elif else_statement.confidence == 1:
		return parser.error(else_statement, else_statement.confidence, checkpoint)
	
	return if_statement


func _parse_if(parser):
	var if_keyword = parser.expect_token("keyword", "if")
	if not parser.is_success(if_keyword):
		return parser.error(if_keyword, 0)
	
	var condition = parser.expect("Expression")
	if not parser.is_success(condition):
		return parser.error("Expected an condition_expression after \"if\".", 1)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to conclude the if statement.", 1)
	
	var block = parser.expect("BlockNode")
	if not parser.is_success(block):
		return parser.error(block, 1)
	
	return IfStatement.new(if_keyword.position, condition, block)


func _parse_elif(parser):
	var elif_keyword = parser.expect_token("keyword", "elif")
	if not parser.is_success(elif_keyword):
		return parser.error(elif_keyword, 0)
	
	var condition = parser.expect("Expression")
	if not parser.is_success(condition):
		return parser.error("Expected an condition_expression after \"elif\".", 1)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to conclude the elif statement.", 1)
	
	var block = parser.expect("BlockNode")
	if not parser.is_success(block):
		return parser.error(block, 1)
	
	return IfStatement.new(elif_keyword.position, condition, block)


func _parse_else(parser):
	var else_keyword = parser.expect_token("keyword", "else")
	if not parser.is_success(else_keyword):
		return parser.error(else_keyword, 0)
	
	if not parser.is_success(parser.expect_token("punctuation", ":")):
		return parser.error("Expected a \":\" to conclude the else statement.", 1)
	
	var block = parser.expect("BlockNode")
	if not parser.is_success(block):
		return parser.error(block, 1)
	
	return ElseStatement.new(else_keyword.position, block)
