class_name SerializationUtils
extends Reference

# Deserialization for each serialized object is not a static method 
# because Godot does not support static method overriding. >:(
static func deserialize(serialized_object):
	var temp_instance = load(serialized_object["script_path"]).new()
	var result = temp_instance.deserialize(serialized_object)
	
	# Free temp_instance to prevent memory leaks incase it
	# temp_instance is not a Reference and is just an Object 
	# (such as with Node classes).
	if not temp_instance is Reference:
		temp_instance.free()
	
	return result

static func serialize_vec2(vector: Vector2):
	return { 
		"x": vector.x,
		"y": vector.y,
	}

static func deserialize_vec2(serialized_vector):
	return Vector2(serialized_vector["x"], serialized_vector["y"])

# Template for serializable objects:

## ----- Serialization ----- #
#
#func serialize() -> Dictionary:
#	return {
#		"script_path": get_script().get_path(),
#	}
#
#func deserialize(serialized_object):
#	var instance = get_script().new()
#	return instance
#
## ----- Serialization ----- #
