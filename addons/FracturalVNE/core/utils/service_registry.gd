extends Node

export(Array, NodePath) var initial_service_paths = []

var services = {}

func _ready():
	for service_path in initial_service_paths:
		add_service(get_node(service_path))

func get_service(service_name):
	return services[service_name]

func add_service(service, custom_service_name = null):
	var service_name = service.name if typeof(custom_service_name) != TYPE_STRING else custom_service_name
	assert(not services.has(service_name), 'Service with name "%s" already exists.' % service_name)
	services[service_name] = service

func add_persistent_service(service, custom_service_name = null):
	add_service(service, custom_service_name)
	
	yield(get_tree(), "idle_frame")
	service.get_parent().remove_child(service)
	add_child(service)
	service.owner = self

func remove_service(service):
	if typeof(service) == TYPE_STRING:
		services.erase(service)
	else:
		services.erase(service.name)

func has_service(service_name):
	return services.has(service_name)
