extends Reference
# Builds a SerializationManager for testing.


const FracUtils = FracVNE.Utils
const SerializationManager = preload("res://addons/FracturalVNE/core/utils/serialization/serialization_manager.gd")

var serializers_holder: Node
var serialization_manager
var serializers: Array = []


func build():
	serialization_manager = SerializationManager.new()
	serialization_manager.serializers_holder = serializers_holder
	if serializers_holder.get_parent() == null:
		serialization_manager.add_child(serializers_holder)
	for serializer in serializers:
		serializers_holder.add_child(serializer)
	return serialization_manager


func inject_serializers_holder(serializers_holder_: Node):
	FracUtils.try_free(serializers_holder)
	serializers_holder = serializers_holder_
	return self


func inject_serializer(serializer: Node):
	serializers.append(serializer)
	return self


func default(_direct):
	inject_serializers_holder(Node.new())
	return self
