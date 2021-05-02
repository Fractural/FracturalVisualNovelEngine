extends "res://addons/FracturalVNE/core/story_script/ast_nodes/node_parser.gd"

func get_parse_types() -> Array:
	return ["program"]

func get_keywords() -> Array:
	return ["program"]

func parse(parser):
	var checkpoint = parser.save_checkpoint()
	var indent = parser.expect_punctuation("INDENT")
	if parser.is_success(indent):
		var statements = []
		while not parser.is_EOF():
			var statement = parser.expect("statement")
			if not parser.is_success(statement):
				return parser.error(statement, 1, checkpoint)
			statements.append(statement)
		return ProgramNode.new(statements)
	else:
		return parser.error(indent, 0)
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class ProgramNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
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
	
	func debug_string(tabs_string: String):						
		var string = ""
		string += tabs_string + "PROGRAM :" 
		string += "\n" + tabs_string + "{"
		
		for statement in statements:
			string += statement.debug_string(tabs_string + "\t") + ", "
		
		string += "\n" + tabs_string + "}"
