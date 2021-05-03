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
			return BlockNode.new(indent.position, statements)
		else:
			return parser.error(indent, 0, checkpoint)
	else:
		return newline
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class BlockNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	static func get_types() -> Array:
		return ._get_added_types(["block"])
	
	var variables: Dictionary
	
	var statements: Array
	var _curr_statement_index: int
	
	func _init(position_, statements_: Array).(position_):
		statements = statements_
	
	func execute(runtime_manager):
		variables = {}
		
		_curr_statement_index = 0;
		runtime_manager.connnect("on_execute", self, "execute_tick")
		_execute_tick(runtime_manager)
	
	func _execute_tick(runtime_manager):
		if _curr_statement_index >= statements.size():
			return
		runtime_manager.execute(statements[_curr_statement_index], self)
	
	func get_variable(name: String):
		if variables.has(name):
			return name
		return StoryScriptError.new('Variable named "%s" could not be found.' % name)
	
	func declare_variable(name: String, value):
		if not variables.has(name):
			variables[name] = Variable.new(name, value)
		else:
			return error('Local variable with name "%s" already exists' % name)
	
	func call_function(name: String, arguments = []):
		runtime_block.call_function(name, arguments)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "BLOCK:" 
		string += "\n" + tabs_string + "{"
		
		for statement in statements:
			string += "\n" + statement.debug_string(tabs_string + "\t") + ", "
		
		string += "\n" + tabs_string + "}"
		return string
		
	class Variable:
		var name
		var value setget set_value, get_value
		var type: String
		
		func _init(name_, value_):
			name = name_
			set_value(value_)
		
		func set_value(new_value):
			value = new_value
			if typeof(new_value) == TYPE_STRING:
				type = "string"
			elif typeof(new_value) == TYPE_INT:
				type = "integer"
			elif typeof(new_value) == TYPE_REAL:
				type = "float"
			elif typeof(new_value) == TYPE_OBJECT:
				type = value.get_type()
		
		func get_value():
			return value
