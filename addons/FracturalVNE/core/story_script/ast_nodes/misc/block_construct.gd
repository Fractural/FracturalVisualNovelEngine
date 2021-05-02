extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_construct.gd"

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
					return parser.error(statement, 1, checkpoint)
				statements.append(statement)
			return BlockNode.new(statements)
		else:
			return parser.error(indent, 0, checkpoint)
	else:
		return newline
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class BlockNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	static func get_types() -> Array:
		return ._get_added_types(["block"])
	
	var statements: Array
	var _curr_statement_index: int
	
	func _init(statements_: Array):
		statements = statements_
	
	func execute(runtime_manager):
		_curr_statement_index = 0;
		runtime_manager.connnect("on_execute", self, "execute_tick")
		_execute_tick(runtime_manager)
	
	func _execute_tick(runtime_manager):
		if _curr_statement_index >= statements.size():
			return
		runtime_manager.execute(statements[_curr_statement_index])
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "BLOCK:" 
		string += "\n" + tabs_string + "{"
		
		for statement in statements:
			string += "\n" + statement.debug_string(tabs_string + "\t") + ", "
		
		string += "\n" + tabs_string + "}"
		return string
