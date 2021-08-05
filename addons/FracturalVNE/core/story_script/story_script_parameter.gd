extends Reference


var name
var default_value


func _init(name_ = null, default_value_ = null):
	name = name_
	default_value = default_value_


func _to_string():
	return "PARAM %s = %s" %[name, str(default_value)]


# ----- Serialization ----- #

func serialize() -> Dictionary:
	return {
		"script_path": get_script().get_path(),
		"name": name,
		"default_value": default_value,
	}


func deserialize(serialized_object):
	var instance = get_script().new()
	instance.name = serialized_object["name"]
	instance.default_value = serialized_object["default_value"]
	return instance

# ----- Serialization ----- #
