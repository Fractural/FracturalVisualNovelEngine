extends "res://addons/FracturalVNE/core/standard_node_2d/standard_node_2d.gd"
# Base class for all ActorControllers.
# Unused right now because of
# ControlActorController and Node2DActorController


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorController", "Serializable"]

# ----- Typeable ----- #


export var actor_animator_path: NodePath
export var actor_mover_path: NodePath
export var actor_transitioner_path: NodePath
export var node_holder_path: NodePath

var actor: Resource

var actor_animator# = get_node(actor_animator_path)
var actor_mover #= get_node(actor_mover_path)
var actor_transitioner #= get_node(actor_transitioner_path)
onready var node_holder = get_node(node_holder_path)


func init(actor_ = null, story_director = null):
	actor = actor_
	
	actor_animator = get_node(actor_animator_path)
	actor_mover = get_node(actor_mover_path)
	actor_transitioner = get_node(actor_transitioner_path)
	
	actor_animator.init(story_director)
	actor_mover.init(story_director)
	actor_transitioner.init(story_director)


func get_node_holder():
	return node_holder


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
