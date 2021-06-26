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


func _init(name_ = null, name_color_ = null, dialogue_color_ = null):
	name = name_
	name_color = name_color_
	dialogue_color = dialogue_color_


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
