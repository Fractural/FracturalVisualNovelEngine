extends Reference
# Stores data about a character.
# Is used by classes such as TextPrinter. 


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["Character"]

# ----- Typeable ----- #


var name
var name_color
var dialogue_color
var visual


func _init(name_ = null, name_color_ = null, dialogue_color_ = null, visual_ = null):
	name = name_
	name_color = name_color_
	dialogue_color = dialogue_color_
	visual = visual_


# ----- Serialization ----- #

# character_serializer.gd

# ----- Serialization ----- #
