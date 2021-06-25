class_name StoryScriptPosition
extends Reference

var line: int
var column: int

func _init(line_: int = 0, column_: int = 0):
	line = line_
	column = column_

func clone() -> StoryScriptPosition:
	return get_script().new(line, column)

func _to_string():
	return "(Line:%s, Col:%s)" % [line, column]

# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"line": line,
		"column": column,
	}

func deserialize(serialized_obj):
	var instance = get_script().new()
	instance.line = serialized_obj["line"]
	instance.column = serialized_obj["column"]
	return instance

# ----- Serialization ----- #
