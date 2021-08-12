extends Node


const SerializationManager = preload("res://addons/FracturalVNE/core/utils/serialization/serialization_manager.gd")
const PartlySerializedObject = SerializationManager.PartlySerializedObject

class ReferenceBasedSerializationManager extends WAT.FakeMock:
	# Simple SerializtionManger that
	# just operates using an array instead of 
	# in a scene tre.
	
	var serializers: Array
	
	
	func _init(direct).(direct, SerializationManager, "Reference"):
		_bind_mock_function("serialize")
		_bind_mock_function("deserialize")
	
	
	func set_serializers(serializers_: Array):
		serializers = serializers_
	
	
	func serialize(object, args):
		var target_object = args[0]
		for serializer in serializers:
			if serializer.can_serialize(target_object):
				return serializer.serialize(target_object)
	
	
	func deserialize(object, args):
		var serialized_object = args[0]
		var auto_fetch_dependencies = args[1]
		for serializer in serializers:
			if serializer.can_deserialize(serialized_object):
				var result = serializer.deserialize(serialized_object)
				if auto_fetch_dependencies:
					return fetch_dependencies(object, [PartlySerializedObject.new(result, serialized_object)])
				else:
					return result
	
	
	func fetch_dependencies(object, args):
		var partly_serialized_object = args[0]
		for serializer in serializers:
			if serializer.has_method("can_fetch_dependencies") and serializer.can_fetch_dependencies(args[0]):
				serializer.fetch_dependencies(partly_serialized_object.object, partly_serialized_object.serialized_object)
				break
		return partly_serialized_object.object


