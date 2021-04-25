class_name StoryScriptToken
extends Reference

var type: String
var symbol
var position: Position

func _init(type_: String, symbol_ = null, position_: Position = null):
	symbol = symbol_
	type = type_
	position = position_

func _to_string() -> String:
	return "[ TYPE: %-15s Line: %-2s[%-2s] SYMBOL: %-10s ]" % [type, str(position.line), str(position.column), str("" if symbol == null else symbol)]

class Position:
	var line: int
	var column: int
	
	func _init(line_: int = 0, column_: int = 0):
		line = line_
		column = column_
		
	func clone() -> Position:
		return Position.new(line, column)
