extends Reference
# Stores data about a character.
# Is used by classes such as TextPrinter. 


var name
var name_color
var dialogue_color


func _init(name_ = null, name_color_ = null, dialogue_color_ = null):
	name = name_
	name_color = name_color_
	dialogue_color = dialogue_color_


# Optional function that is called whenever an object is instantiated within
# a story as a variable. This can be used to populate services that track
# certain types of objects (ie. CharacterManager tracking all Character
# instances in a story). And since all variables are stored in the order they
# are added, these services would be populated with the exact same data in the
# exact same order every time, which allows for saving and loading of a story's
# variables.
#
# Note that it is the developer's responsibility to call "_story_init()" if
# they plan on serializing the object when the story saves.
func _story_init():
	StoryServiceRegistry.get_service("StoryReferenceRegistry").add_reference(self)


# ----- Serialization ----- #

func serialize():
	return {
		"script_path": get_script().get_path(),
		"name": name,
		"name_color": name_color.to_html(),
		"dialogue_color": dialogue_color.to_html(),
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.name = serialized_object["name"]
	instance.name_color = Color(serialized_object["name_color"])
	instance.dialogue_color = Color(serialized_object["dialogue_color"])
	return instance

# ----- Serialization ----- #
