extends Reference
# A testing double for SerializationUtils.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["SerializationUtils", "TestDouble"]

# ----- Typeable ----- #


signal 	_called__deserialize()
var 	_return__deserialize
func deserialize():
	emit_signal("_called__deserialize")
	return _return__deserialize


signal 	_called__deserialize_vec2()
var 	_return__deserialize_vec2
func deserialize_vec2():
	emit_signal("_called__deserialize_vec2")
	return _return__deserialize_vec2
