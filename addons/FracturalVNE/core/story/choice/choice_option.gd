extends Reference
# Holds information about an option for a choice.
# This class is made in anticipation of adding
# parameters to the choice statement.
# (Parameters would then be stored here as well,
# where it can then be accessed by option controllers,
# etc.)


var text: String
var is_valid: bool


func _init(text_: String, is_valid_: bool):
	text = text_
	is_valid = is_valid_
