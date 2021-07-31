extends Node
# Base class for all ActorControllers.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorController"]

# ----- Typeable ----- #


export var actor_animator_path: NodePath
export var actor_mover_path: NodePath
export var actor_transitioner_path: NodePath

var actor: Resource

onready var actor_animator = get_node(actor_animator_path)
onready var actor_mover = get_node(actor_mover_path)
onready var actor_transitioner = get_node(actor_transitioner_path)


func init(actor_ = null, story_director = null):
	actor = actor_
	
	actor_animator = get_node(actor_animator_path)
	actor_mover = get_node(actor_mover_path)
	actor_transitioner = get_node(actor_transitioner_path)
	
	actor_animator.init(story_director)
	actor_mover.init(story_director)
	actor_transitioner.init(story_director)


func get_actor_animator():
	return actor_animator


func get_actor_mover():
	return actor_mover


func get_actor_transitioner():
	return actor_transitioner


func get_actor():
	return actor

# ----- Serialization ----- #

# actor_controller_serializer.gd

# ----- Serialization ----- #
