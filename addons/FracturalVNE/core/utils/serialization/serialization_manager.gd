extends Node
# Handles serialization and deserialization of any object.
# Checks with each serializer to see if it can serialize a given object
# and if it can, then it uses that serializer to serialize/deserialize
# the object.

# This setup allows for dependency injection within serializers as 
# serialization is now taken out of the object class and put into its own class.


export var serializers_holder_path: NodePath

onready var serializers_holder = get_node(serializers_holder_path)


# Serialize an object either with a serialize function within itself or with
# a dedicated serializer node.
func serialize(object):
	if object.has_method("serialize"):
		return object.serialize()
	
	for serializer in serializers_holder.get_children():
		if serializer.can_serialize(object):
			return serializer.serialize(object)


# If auto_fetch_dependencies is true, then returns the fully deserialized object
# If auto_fetch_dependencies is false, then returns a PartlyDeserializedObject
# which contains both the partly serialized object and the serialized object.
# The PartlySerializedObject should be passed into fetch_dependencies()
# at some point later to finish the deserialization.
func deserialize(serialized_object, auto_fetch_dependencies = true):
	var result
	for serializer in serializers_holder.get_children():
		if serializer.can_deserialize(serialized_object):
			result = serializer.deserialize(serialized_object)
			
			var partly_serialized_object = PartlySerializedObject.new(result, serialized_object)
			if auto_fetch_dependencies:
				return fetch_dependencies(partly_serialized_object)
			else:
				return partly_serialized_object
	
	# If none of the serializers can handle the serialized object,
	# then try to deserialize the object normally.
	result = SerializationUtils.deserialize(serialized_object)
	
	var partly_serialized_object = PartlySerializedObject.new(result, serialized_object)
	if auto_fetch_dependencies:
		fetch_dependencies(result)
	return result


# Fetches the dependencies of an object after it is serialized.
# This is normally done immediately after serialization but it can
# be controlled if a serialized object is deserialized with 
# auto_fetch_dependencies set to false.
func fetch_dependencies(partly_serialized_object):
	for serializer in serializers_holder.get_children():
		if serializer.has_method("can_fetch_dependencies") and serializer.can_fetch_dependencies(partly_serialized_object.object):
			serializer.fetch_dependencies(partly_serialized_object.object, partly_serialized_object.serialized_object)


class PartlySerializedObject extends Reference:
	var object
	var serialized_object
	
	func _init(object_, serialized_object_):
		object = object_
		serialized_object = serialized_object_
