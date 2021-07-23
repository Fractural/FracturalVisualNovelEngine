class_name StoryScriptPosition
extends Reference
# Stores the position for something in a StoryScript using the line and column it appears in.


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


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.line = serialized_object["line"]
	instance.column = serialized_object["column"]
	return instance

# ----- Serialization ----- #
