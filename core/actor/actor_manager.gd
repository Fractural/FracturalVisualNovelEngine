extends Node
# Creates and keeps track of Actors.

# TODO: Maybe remove asserts?


# ----- StoryService ----- #


func configure_service(program_node):
	for actor in actor_controller_lookup.values():
		actor.queue_free()
	actor_controller_lookup = {}
	actors = []


func get_service_name():
	return "ActorManager"

# ----- StoryService ----- #


const FracUtils = FracVNE.Utils
const SSUtils = FracVNE.StoryScript.Utils

export var reference_registry_path: NodePath
export var actors_holder_path: NodePath
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
onready var actors_holder = get_node(actors_holder_path)
onready var story_director = get_node(story_director_path)
onready var serialization_manager = get_node(serialization_manager_path)


func add_actor(actor):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	actors.append(actor)


func remove_actor(actor):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	actors.erase(actor)
	actor_controller_lookup.erase(actor)


# ----- TEMP DEBUG ----- #

var counter: int = 0

# ----- TEMP DEBUG ----- #

# -- StoryScriptErrorable -- #
func load_actor_controller(actor, actor_parent = null):
	var actor_controller = actor.instantiate_controller(story_director)

	if not SSUtils.is_success(actor_controller):
		return SSUtils.stack_error(actor_controller, "Could not load the actor controller.")

	actor_controller_lookup[actor] = actor_controller
	
	if actor_parent != null:
		actor_parent.add_child(actor_controller)
	else:
		actors_holder.add_child(actor_controller)
	
	# ----- TEMP DEBUG ----- #
	
	actor_controller.name += " %s" % str(counter)
	counter += 1
	
	# ----- TEMP DEBUG ----- #
	
	return actor_controller


func remove_actor_controller(actor):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	var result = actor_controller_lookup[actor]
	actor_controller_lookup[actor].queue_free()
	actor_controller_lookup.erase(actor)


# -- StoryScriptErrorable -- #
# Returns the actor_controller that belongs to the actor. If there is none
# then the a new actor_controller will be loaded, assigned to the actor, 
# and returned.
func get_or_load_actor_controller(actor):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	var actor_controller = actor_controller_lookup.get(actor)
	if actor_controller != null:
		return actor_controller
	return load_actor_controller(actor)


# Trys to get the actor controller that corresponds with a certain actor.
# If no such controller can be found, this method returns null.
func get_actor_controller(actor):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	return actor_controller_lookup.get(actor)



# -- StoryScriptErrorable -- #
func add_new_actor(actor, cached, actor_holder = null):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	reference_registry.add_reference(actor)
	add_actor(actor)
	
	# If we are caching the actor controller when we create the actor, then we must
	# load the actor controller immediately (So it will be there for later use).
	if cached:
		var load_result = load_actor_controller(actor, actor_holder)
		if not SSUtils.is_success(load_result):
			return load_result


func add_new_actor_with_controller(actor, actor_controller):
	assert(FracUtils.is_type(actor, "Actor"), "Expected actor to be an Actor.")
	assert(FracUtils.is_type(actor_controller, "ActorController"), 
		"Expected actor_controller to be an ActorController.")
	reference_registry.add_reference(actor)
	add_actor(actor)
	actor_controller_lookup[actor] = actor_controller

# ----- Serialization ----- #

func serialize_state() -> Dictionary:
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


func deserialize_state(serialized_state) -> void:
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
