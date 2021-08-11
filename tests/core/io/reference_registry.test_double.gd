extends Node
# A testing double for ReferenceRegistry.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ReferenceRegistry", "TestDouble"]

# ----- Typeable ----- #


# ----- StoryService ----- #

signal 	_called__get_service_name()
var 	_return__get_service_name
func get_service_name():
	emit_signal("_called__get_service_name")
	return _return__get_service_name

# ----- StoryService ----- #


signal 	_called__add_reference(reference)
var 	_return__add_reference
func add_reference(reference: Object):
	emit_signal("_called__add_reference", reference)
	return _return__add_reference


signal 	_called__remove_reference(reference)
var 	_return__remove_reference
func remove_reference(reference: Object):
	emit_signal("_called__remove_reference", reference)
	return _return__remove_reference


signal 	_called__get_reference(id)
var 	_return__get_reference
func get_reference(id: int):
	emit_signal("_called__get_reference", id)
	return _return__get_reference


signal 	_called__get_reference_id(reference)
var 	_return__get_reference_id
func get_reference_id(reference: Object):
	emit_signal("_called__get_reference_id", reference)
	return _return__get_reference_id


# ----- Serialization ----- #

signal 	_called__serialize_state()
var 	_return__serialize_state
func serialize_state():
	emit_signal("_called__serialize_state")
	return _return__serialize_state


signal 	_called__deserialize_state(serialized_state)
var 	_return__deserialize_state
func deserialize_state(serialized_state):
	emit_signal("_called__deserialize_state")
	return _return__deserialize_state

# ----- Serialization ----- #
