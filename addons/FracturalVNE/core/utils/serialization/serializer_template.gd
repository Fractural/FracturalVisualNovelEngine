extends Node
# Template for creating custom serializers for objects


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	return {
		"script_path": _script_path(),
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = load(_script_path()).new()
	
	return instance


# Optional
func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


# Optional
func fetch_dependencies(instance, serialized_object):
	pass


func _script_path():
	return "res://..."
