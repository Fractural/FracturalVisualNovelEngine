class_name WATFakeMock
extends Reference
# A wrapper for a ScriptDirector that allows for custom implementations.
# This makes it easier to fake objects.


var mock_object


func _init(direct, type, blank_impl_type: String = "Reference"):
	mock_object = direct.script_blank(type, blank_impl_type)


func _bind_mock_function(func_name: String, target_func_name: String = ""):
	if target_func_name == "":
		target_func_name = func_name
	mock_object.method(func_name).subcall(funcref(self, target_func_name))


func double():
	return mock_object.double()
