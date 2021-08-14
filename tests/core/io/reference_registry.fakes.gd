extends Node
# Holds the different fake classes for StoryDirector.


const ReferenceRegistry = preload("res://addons/FracturalVNE/core/io/reference_registry.gd")


class TestGetAddReference extends WAT.FakeMock:
	var references = []
	
	
	func _init(direct).(direct, ReferenceRegistry):
		_bind_mock_function("add_reference")
		_bind_mock_function("remove_reference")
		_bind_mock_function("get_reference")
		_bind_mock_function("get_reference_id")
	
	
	# ----- Binded ----- #
	
	func add_reference(_object, args):
		var reference = args[0]
		if not references.has(reference):
			references.append(reference)
	
	
	func remove_reference(_object, args):
		var reference = args[0]
		references.erase(reference)
	
	
	func get_reference(_object, args):
		var id = args[0]
		return references[id]
	
	
	func get_reference_id(_object, args):
		var reference = args[0]
		return references.find(reference)
	
	# ----- Binded ----- #
