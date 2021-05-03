extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement_construct.gd"

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
					return parser.error(block, 3/4.0, checkpoint)
			else:
				return parser.error(colon, 2/4.0, checkpoint)
		else:
			return parser.error(identifier, 1/4.0, checkpoint)
	else:
		return parser.error(label, 0)
# TODO NOW: Port over ast_nodes following the google drawings UML diagram

class LabelNode extends "res://addons/FracturalVNE/core/story_script/ast_nodes/executable_node.gd":
	var name: String
	var block
	
	func _init(position_, name_: String, block_).(position_):
		name = name_
		block = block_
	
	func execute(runtime_manager):
		# TODO Add add_label
		runtime_manager.add_label(self)
	
	func debug_string(tabs_string: String) -> String:
		var string = ""
		string += tabs_string + "LABEL " + name + ":" 
		string += "\n" + tabs_string + "{"
		string += "\n" + block.debug_string(tabs_string + "\t")
		string += "\n" + tabs_string + "}"
		return string
