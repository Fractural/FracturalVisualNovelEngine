extends Reference
# A wrapper for a ScriptDirector that allows for custom implementations.
# This makes it easier to fake objects.


var mock_object


func _init(direct, type):
	mock_object = direct.script(type)


func _bind_mock_function(func_name: String, target_func_name: String = ""):
	if target_func_name == "":
		target_func_name = func_name
	mock_object.method(func_name).sub_call(funcref(self, target_func_name))


func double():
	mock_object.double
