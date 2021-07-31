class_name FracVNE_CharactersDelay, "res://addons/FracturalVNE/assets/icons/characters_delay.svg"
extends Resource
# Used in TextReveal and holds information about the 
# reveal delay used for a set of characters.


export var characters: String
export var delay: float


func _init(characters_ = "", delay_ = 0):
	characters = characters_
	delay = delay_


# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"characters": characters,
		"delay": delay,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.characters = serialized_object["characters"]
	instance.delay = serialized_object["delay"]

# ----- Serialization ----- #
