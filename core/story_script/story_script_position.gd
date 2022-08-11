extends Reference
# Stores the position for something in a StoryScript using the line and column it appears in.

# TODO: Add support for attaching a file_path to a posiition.
#		This allows for more detailed stack traces, which are
#		espcially important when using import statements to
#		import in external StoryScripts.


var line: int
var column: int


func _init(line_: int = 0, column_: int = 0):
	line = line_
	column = column_


func clone():
	return get_script().new(line, column)


# StoryScriptPositions are stored with zero-indexing.
# This means line 0 is the first line and
# column 0 is the first column.
# Normal text editors use one-indexing, therefore
# this method is used for any one-indexing printing.
func to_one_indexed_string():
	return "(Line:%s, Col: %s)" % [line + 1, column + 1]


func _to_string():
	return "(Line:%s, Col:%s)" % [line, column]


# ----- Serialization ----- #

func serialize() -> Dictionary:
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
