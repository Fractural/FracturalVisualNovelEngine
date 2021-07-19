class_name StoryScriptToken
extends Reference

var type: String
var symbol
var position: StoryScriptPosition

func _init(type_: String, symbol_ = null, position_: StoryScriptPosition = null):
	symbol = symbol_
	type = type_
	position = position_

func _to_string() -> String:
	return "[ TYPE: %-15s Line: %-3s[%-3s] SYMBOL: %-10s ]" % [type, str(position.line), str(position.column), str("" if symbol == null else symbol)]
