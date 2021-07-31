extends Node
# Creates and keeps track of Actors.


# ----- StoryService ----- #


func configure_service(program_node):
	for actor in actor_controller_lookup.values():
		actor.queue_free()
	actor_controller_lookup = {}
	actors = []


func get_service_name():
	return "ActorManager"

# ----- StoryService ----- #


const SSUtils = FracVNE.StoryScript.Utils

export var reference_registry_path: NodePath
export var node_2d_actors_holder_path: NodePath
export var control_actors_holder_path: NodePath
export var story_director_path: NodePath
export var serialization_manager_path: NodePath


# The active actor controller that is associated with this actor if any.
# Each actor can have one unique active actor controller associated with it.
# The Actor + ActorController pairs are stored in this dictionary.
#
# Keys: Actor
# Values: ActorController
var actor_controller_lookup: Dictionary = {}
var actors: Array = []

onready var reference_registry = get_node(reference_registry_path)
onready var node_2d_actors_holder = get_node(node_2d_actors_holder_path)
onready var control_actors_holder = get_node(control_actors_holder_path)
onready var story_director = get_node(story_director_path)
onready var serialization_manager = get_node(serialization_manager_path)


func get_actors_holder(actor_controller):
	if actor_controller is Control:
		return control_actors_holder
	return node_2d_actors_holder


func add_actor(actor):
	actors.append(actor)


func remove_actor(actor):
	actors.erase(actor)
	actor_controller_lookup.erase(actor)


func load_actor_controller(actor, actor_holder = null):
	var actor_controller = actor.instantiate_controller(story_director)

	if not SSUtils.is_success(actor_controller):
		return SSUtils.stack_error(actor_controller, "Cannot load the actor controller.")

	actor_controller_lookup[actor] = actor_controller
	
	if actor_holder == null:
		get_actors_holder(actor_controller).add_child(actor_controller)
	else:
		actor_holder.add_child(actor_controller)
	
	return actor_controller


func remove_actor_controller(actor):
	actor_controller_lookup[actor].queue_free()
	actor_controller_lookup.erase(actor)


# Returns the actor_controller that belongs to the actor. If there is none
# then the a new actor_controller will be loaded, assigned to the actor, 
# and returned.
func get_or_load_actor_controller(actor):
	var actor_controller = actor_controller_lookup.get(actor)
	if actor_controller != null:
		return actor_controller
	return load_actor_controller(actor)


func add_new_actor(actor, cached, actor_holder = null):
	reference_registry.add_reference(actor)
	add_actor(actor)
	
	# If we are caching the actor controller when we create the actor, then we must
	# load the actor controller immediately (So it will be there for later use).
	if cached:
		var load_result = load_actor_controller(actor, actor_holder)
		if not SSUtils.is_success(load_result):
			return load_result


# ----- Serialization ----- #

func serialize_state():
	var serialized_actor_controller_lookup = {}
	for actor in actor_controller_lookup.keys():
		var actor_id = reference_registry.get_reference_id(actor)
		serialized_actor_controller_lookup[actor_id] = serialization_manager.serialize(actor_controller_lookup[actor])
	
	var actor_ids = []
	for actor in actors:
		actor_ids.append(reference_registry.get_reference_id(actor))
	
	return {
		"service_name": get_service_name(),
		"actor_controller_lookup": serialized_actor_controller_lookup,
		"actor_ids": actor_ids,
	}


func deserialize_state(serialized_state):
	for actor in actor_controller_lookup.values():
		actor.queue_free()
	actor_controller_lookup = {}
	actors = []
	
	for actor_id in serialized_state["actor_controller_lookup"].keys():
		# We have to cast actor_id to an int since serialized dictionaries 
		# cannot store ints??
		var actor_controller = serialization_manager.deserialize(serialized_state["actor_controller_lookup"][actor_id])
		actor_controller_lookup[reference_registry.get_reference(int(actor_id))] = actor_controller
		
		# No need to add child since that is handled in the 
		# serialization of the Actor.
		
	for actor_id in serialized_state["actor_ids"]:
		actors.append(reference_registry.get_reference(actor_id))

# ----- Serialization ----- #
