extends "actor_controller_serializer.gd"


func serialize(object):
	var serialized_object = .serialize(object)
	serialized_object["visible"] = object.visible
	serialized_object["global_position"] = SerializationUtils.serialize_vec2(object.global_position)
	serialized_object["global_rotation"] = object.global_rotation
	serialized_object["global_scale"] = SerializationUtils.serialize_vec2(object.global_scale)
	return serialized_object


func deserialize(serialized_object):
	var instance = .deserialize(serialized_object)	
	instance.visible = serialized_object["visible"]
	instance.global_position = SerializationUtils.deserialize_vec2(serialized_object["global_position"])
	instance.global_rotation = serialized_object["global_rotation"]
	instance.global_scale = SerializationUtils.deserialize_vec2(serialized_object["global_scale"])
	return instance
