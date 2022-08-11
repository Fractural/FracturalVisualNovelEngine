class_name FracVNE_Character, "res://addons/FracturalVNE/assets/icons/character.svg"
extends Resource
# Stores data about a character.
# Is used by classes such as TextPrinter. 


# ----- Typeable ----- #

func get_cast_types() -> Array:
	if visual != null:
		return visual.get_types()
	return []


func cast(type: String):
	if get_types().has(type):
		return self
	if visual.get_types().has(type):
		return visual


func get_types() -> Array:
	return ["Character", "Serializable"]

# ----- Typeable ----- #


export var name: String
export var name_color: Color
export var dialogue_color: Color
export var visual: Resource


func _init(name_ = "", name_color_ = Color.white, dialogue_color_ = Color.white, visual_ = null):
	name = name_
	name_color = name_color_
	dialogue_color = dialogue_color_
	visual = visual_


# ----- Serialization ----- #

# character_serializer.gd

# ----- Serialization ----- #
