extends Reference
# Holds the arguments of a function and can also call that function with
# the stored arguments.


var instance
var function
var arguments


func _init(instance_ = null, function_ = null, arguments_ = null):
	instance = instance_
	function = function_
	arguments = arguments_


func call_func():
	instance.callv("function", arguments)
