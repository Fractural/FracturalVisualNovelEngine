extends Node
# A dependency injection container (DI container) that injects dependencies
# into new scene before they are loaded.

# This container's scene is always ran first to "auto load" it without having
# to force the developer to add this container to the Project's AutoLoad settings.

# The DI Container will only be used on standalone versions 
# of the StoryScriptEditor.


signal readied()

export var is_self_contained: bool = false
export var scene_manager_path: NodePath
export var services_holder_path: NodePath
export(Array, NodePath) var preloaded_service_paths: Array

var services = []

onready var scene_manager = get_node(scene_manager_path)
onready var services_holder = get_node(services_holder_path)


func _ready() -> void:
	for injectable_service in services_holder.get_children():
		services.append(injectable_service)
	
	scene_manager.connect("scene_loaded", self, "_on_scene_loaded")
	
	# TODO: Maybe remove this? What does the idle_frame do?
	yield(get_tree(), "idle_frame")
	
	if not is_self_contained:
		var root = get_tree().root
		get_parent().remove_child(self)
		root.add_child(self)
	
	scene_manager.goto_initial_scene()
	emit_signal("readied")


func has_service(new_injectable_service):
	for injectable_service in services:
		if injectable_service.get_path() == new_injectable_service.get_path():
			# The injectable_service already exists
			return true
	return false


func add_service(new_injectable_service):
	services_holder.add_child(new_injectable_service)
	services.append(new_injectable_service)


func try_add_service(new_injectable_service):
	if has_service(new_injectable_service):
		return false
	
	add_service(new_injectable_service)
	return true


func _on_scene_loaded(loaded_scene):
	if not loaded_scene.has_node("Dependencies"):
		return
	
	var dependencies_holder = loaded_scene.get_node("Dependencies")
	var dependency_requesters = dependencies_holder.get_children()
	
	for requester in dependency_requesters:
		# Let each injectable_service try to inject a dependency
		for injectable_service in services:
			if FracVNE.Utils.is_type(injectable_service, requester.dependency_name):
				_inject_dependency(requester, injectable_service)
				break


func _inject_dependency(requester, injectable_service):
	requester.dependency_path = injectable_service.get_path()
