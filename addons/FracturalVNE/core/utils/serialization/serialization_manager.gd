extends Node
# Handles serialization and deserialization of any object.
# Checks with each serializer to see if it can serialize a given object
# and if it can, then it uses that serializer to serialize/deserialize
# the object.

# This setup allows for dependency injection within serializers as 
# serialization is now taken out of the object class and put into its own class.


export var serializers_holder_path: NodePath

onready var serializers_holder = get_node(serializers_holder_path)


func serialize(object):
	if object.has_method("serialize"):
		return object.serialize()
	
	for serializer in serializers_holder.get_children():
		if serializer.can_serialize(object):
			return serializer.serialize(object)


func deserialize(object):
	for serializer in serializers_holder.get_children():
		if serializer.can_deserialize(object):
			return serializer.deserialize(object)
