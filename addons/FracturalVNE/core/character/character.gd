class_name FracVNE_Character, "res://addons/FracturalVNE/assets/icons/character.svg"
extends Resource
# Stores data about a character.
# Is used by classes such as TextPrinter. 


# ----- Typeable ----- #

func can_cast(type: String) -> bool:
	return type == "Visual"


func cast(type: String):
	match type:
		"Visual":
			return visual
		_:
			return null


func get_types() -> Array:
	return ["Character"]

# ----- Typeable ----- #


export var name: String
export var name_color: Color
export var dialogue_color: Color
export var visual: Resource


func _init(name_ = null, name_color_ = null, dialogue_color_ = null, visual_ = null):
	name = name_
	name_color = name_color_
	dialogue_color = dialogue_color_
	visual = visual_


# ----- Serialization ----- #

# character_serializer.gd

# ----- Serialization ----- #
