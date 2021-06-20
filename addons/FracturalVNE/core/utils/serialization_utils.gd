class_name SerializationUtils
extends Reference

# Deserialization is not a static method because Godot does not support
# static method overriding. >:(
static func deserialize(serialized_object):
	return load(serialized_object["script_path"]).new().deserialize(serialized_object)

# Template for serializable objects:

## ----- Serialization ----- #
#
#func serialize():
#	return {
#		"script_path": get_script().get_path(),
#	}
#
#static func deserialize(save_state):
#	var instance = load(get_script().get_path()
#	return instance
#
## ----- Serialization ----- #
