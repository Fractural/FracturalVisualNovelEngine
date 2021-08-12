extends Reference
# Builds a SerializationManager for testing.


const SerializationManager = preload("res://addons/FracturalVNE/core/utils/serialization/serialization_manager.gd")


var serializers_holder: Node
var serialization_manager


func build():
	serialization_manager = SerializationManager.new()
	serialization_manager.serializers_holder = serializers_holder
	if serializers_holder.get_parent() == null:
		serialization_manager.add_child(serializers_holder)
	return serialization_manager


func inject_serializers_holder(serializers_holder_: Node):
	serializers_holder = serializers_holder_
	return self


func default(_direct):
	serializers_holder = Node.new()
	return self
