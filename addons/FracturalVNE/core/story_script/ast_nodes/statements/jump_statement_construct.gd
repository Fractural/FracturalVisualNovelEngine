extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("jump")
	return arr

func get_keywords() -> Array:
	return ["jump"]

func parse(parser):
	var checkpoint = parser.save_reader_state()
	var jump = parser.expect_token("keyword", "jump")
	if parser.is_success(jump):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			if parser.is_success(parser.expect_token("punctuation", "newline")):
				return JumpNode.new(jump.position, identifier.symbol)
			return parser.error("Expected a new line to conclude a statement.", 1/2.0, checkpoint)
		else:
			return parser.error(identifier, 1/2.0, checkpoint)
	else:
		return parser.error(jump, 0)

class JumpNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	static func get_types() -> Array:
		var arr = .get_types()
		arr.append("jump")
		return arr
	
	var label_name: String
	
	func _init(position_, label_name_: String).(position_):
		label_name = label_name_
	
	func execute(runtime_manager):
		# TODO Add jump_to_label
		runtime_manager.jump_to_label(label_name)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "JUMP -> " + label_name 
		return string
