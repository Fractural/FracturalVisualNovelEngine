extends Reference
# A testing double for SerializationManager


# ----- Typeable ----- #

func get_types() -> Array:
	return ["SerializationManager", "TestDouble"]

# ----- Typeable ----- #


signal 	_called__serialize()
var 	_returned_serialize
func serialize(object):
	emit_signal("_called__serialize")
	return _returned_serialize


signal 	_called__deserialize()
var 	_returned_deserialize
func deserialize(serialized_object, auto_fetch_dependencies = true):
	emit_signal("_called__deserialize")
	return _returned_deserialize
	

signal 	_called__fetch_dependencies()
var 	_returned_fetch_dependencies
func fetch_dependencies(partly_serialized_object):
	emit_signal("_called__fetch_dependencies")
	return _returned_fetch_dependencies
