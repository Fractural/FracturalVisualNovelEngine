extends Node
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
	}


func can_deserialize(serialized_object):
	return serialized_object.script_path == _script_path()


func deserialize(serialized_object):
	var actor_prefab = load(_get_controller_prefab_path())
	
	var instance = actor_prefab.instance()
	get_node(serialized_object["parent_path"]).add_child(instance)
	return instance


func can_fetch_dependencies(object):
	return object.get_script().get_path() == _script_path()


func fetch_dependencies(instance, serialized_object):
	var actor = reference_registry.get_reference_id(serialized_object["actor_id"])
	instance.init(actor, story_director)


func _get_controller_prefab_path():
	pass


func _script_path():
	return "res://addons/FracturalVNE/core/actor/actor_controller.gd"
