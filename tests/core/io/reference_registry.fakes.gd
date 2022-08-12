extends Node
# Holds the different fake classes for StoryDirector.


const ReferenceRegistry = preload("res://addons/FracturalVNE/core/io/reference_registry.gd")


class TestGetAddReference:
	var references = []
	
	
	func _init():
		pass
	
	
	# ----- Binded ----- #
	
	func add_reference(reference):
		if not references.has(reference):
			references.append(reference)
	
	
	func remove_reference(reference):
		references.erase(reference)
	
	
	func get_reference(id):
		return references[id]
	
	
	func get_reference_id(reference):
		return references.find(reference)
	
	# ----- Binded ----- #
