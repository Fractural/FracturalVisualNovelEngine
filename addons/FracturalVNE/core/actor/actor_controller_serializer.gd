extends Node
# -- Abstract Class -- #
# Handles serialization for the ActorController class


export var story_director_path: NodePath
export var reference_registry_path: NodePath

onready var story_director = get_node(story_director_path)
onready var reference_registry = get_node(reference_registry_path)


func can_serialize(object):
	return object.get_script().get_path() == _script_path()


func serialize(object):
	return {
		"script_path": _script_path(),
		"parent_path": object.get_parent().get_path(),
		"actor_id": reference_registry.get_reference_id(object.actor),
		"visible": object.visible,
		"position": SerializationUtils.serialize_vec2(object.standard_position),
		"scale": SerializationUtils.serialize_vec2(object.standard_scale),
		"rotation": object.standard_rotation,
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var instance = _get_controller_prefab().instance()
	instance.visible = serialized_object["visible"]
	instance.standard_position = SerializationUtils.deserialize_vec2(serialized_object["position"])
	instance.standard_scale = SerializationUtils.deserialize_vec2(serialized_object["scale"])
	instance.standard_rotation = serialized_object["rotation"]
	get_node(serialized_object["parent_path"]).add_child(instance)
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	var actor = reference_registry.get_reference(serialized_object["actor_id"])
	instance.init(actor, story_director)


func _get_controller_prefab():
	pass


func _script_path():
	return get_script().get_path().get_base_dir() + "/actor_controller.gd"
