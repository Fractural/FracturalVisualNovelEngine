extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_parser.gd"

func get_parse_types() -> Array:
	var arr = .get_parse_types()
	arr.append("jump")
	return arr

func get_keywords() -> Array:
	return ["jump"]

func parse(parser):
	var checkpoint = parser.save_checkpoint()
	var jump = parser.expect_token("keyword", "jump")
	if parser.is_success(jump):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			return JumpNode.new(identifier.symbol)
		else:
			return parser.error(identifier, 1/2.0, checkpoint)
	else:
		return parser.error(jump, 0)

class JumpNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var label_name: String
	
	func _init(label_name_: String):
		label_name = label_name_
	
	func execute(runtime_manager):
		# TODO Add jump_to_label
		runtime_manager.jump_to_label(label_name)
	
	func debug_string(indent: int):
		var tabs_string = ""
		for i in range(indent):
			tabs_string += "\t"
			
		var string = ""
		string += tabs_string + "JUMP -> " + label_name 
		return string
