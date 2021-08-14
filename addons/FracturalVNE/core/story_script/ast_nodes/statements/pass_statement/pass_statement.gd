extends "res://addons/FracturalVNE/core/story_script/ast_nodes/statements/statement/statement_node.gd"
# Fill the requirement of a statement but does nothing.
# Used make things like an empty block compile.


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("PassStatement")
	return arr

# ----- Typeable ----- #



func _init(position_ = null).(position_):
	pass
	

func debug_string(tabs_string: String) -> String:
	var string = ""
	string += tabs_string + "PASS" 
	return string


# ----- Serialization ----- #

# Uses parent serialization.

# ----- Serialization ----- #
