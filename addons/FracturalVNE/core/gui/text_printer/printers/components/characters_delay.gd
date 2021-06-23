extends Resource
# Used in TextReveal and holds information about the 
# reveal delay used for a set of characters.


var characters: String
var delay: float


func _init(characters_: String, delay_: float):
	characters = characters_
	delay = delay_
