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

class BlockNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	static func get_types() -> Array:
		return ._get_added_types(["block"])
	
	var statements: Array
	
	# Runtime variables
	var variables: Dictionary
	
	func _init(position_, statements_: Array).(position_):
		statements = statements_
		
		if statements.size() > 0:
			statements.front().runtime_block = self
			for i in range(1, statements.size()):
				statements[i].runtime_block = self
				statements[i - 1].runtime_next_node = statements[i]
	
	func execute():
		variables = {}
		# Blocks cannot be empty
		# TODO: Add a check to prevent empty blocks in parser
		statements.front()
		# Bind the last
		statements.back().connect("executed", self, block_completed())
	
	func block_completed():
		.execute()
	
	func get_service(name: String):
		return runtime_block.get_service(name)
	
	func has_variable(name: String):
		return variables.has(name)
	
	func get_variable(name: String):
		if variables.has(name):
			return variables[name]
		return StoryScriptError.new('Variable named "%s" could not be found.' % name)
	
	func set_variable(name: String, value):
		if variables.has(name):
			variables[name] = value
		else:
			StoryScriptError.new('Variable named "%s" could not be found.' % name)
	
	func declare_variable(name: String, value = null):
		if not variables.has(name):
			variables[name] = value
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
	
	func propagate_call(method, arguments, parent_first = false):
		if parent_first:
			.propagate_call(method, arguments, parent_first)
		
		for statement in statements:
			statement.propagate_call(method, arguments, parent_first)
		
		if not parent_first:
			.propagate_call(method, arguments, parent_first)
