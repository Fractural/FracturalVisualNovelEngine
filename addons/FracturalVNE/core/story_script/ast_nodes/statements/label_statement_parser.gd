extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_parser.gd"

func get_parse_types():
	var arr = .get_parse_types()
	arr.append("label")
	return arr

func get_keywords() -> Array:
	return ["label"]

func parse(parser):
	var checkpoint = parser.save_checkpoint()
	var label = parser.expect_token("keyword", "label")
	if parser.is_success(label):
		var identifier = parser.expect_token("identifier")
		if parser.is_success(identifier):
			var block = parser.expect("block")
			if parser.is_success(block):
				return LabelNode.new(identifier.symbol, block)
			else:
				return parser.error(block, 2/3.0, checkpoint)
		else:
			return parser.error(identifier, 1/3.0, checkpoint)
	else:
		return parser.error(label, 0)
# TODO NOW: Port over constructs following the google drawings UML diagram

class LabelNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var name: String
	var block
	
	func _init(name_: String, block_):
		name = name_
		block = block_
	
	func execute(runtime_manager):
		# TODO Add add_label
		runtime_manager.add_label(self)
	
	func debug_string(indent: int):
		var tabs_string = ""
		for i in range(indent):
			tabs_string += "\t"
						
		var string = ""
		string += tabs_string + "LABEL " + name + " :" 
		string += "\n" + tabs_string + "{"
		string += "\n" + tabs_string + block.debug_string(indent + 1)
		string += "\n" + tabs_string + "}"
