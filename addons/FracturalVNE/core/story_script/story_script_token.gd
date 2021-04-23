class_name StoryScriptToken
extends Reference

var type: String
var symbol
var line: int
var column: int

func _init(type_: String, symbol_, line_: int, column_: int):
	symbol = symbol_
	type = type_
	line = line_
	column = column_

func _to_string() -> String:
	return "[ TYPE: %-15s Line: %-2s[%-2s] SYMBOL: %-10s ]" % [type, str(line), str(column), str("" if symbol == null else symbol)]
