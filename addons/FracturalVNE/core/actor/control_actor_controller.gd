tool
extends "res://addons/FracturalVNE/core/standard_node_2d/control_standard_node_2d.gd"
# -- Abstract Class -- #
# Base class for all Control based ActorControllers.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["ActorController"]

# ----- Typeable ----- #


export var actor_animator_path: NodePath
export var actor_mover_path: NodePath
export var actor_transitioner_path: NodePath
export var node_holder_path: NodePath

var actor: Resource

onready var actor_animator = get_node(actor_animator_path)
onready var actor_mover = get_node(actor_mover_path)
onready var actor_transitioner = get_node(actor_transitioner_path)
onready var node_holder = get_node(node_holder_path)


func init(actor_ = null, story_director = null):
	actor = actor_
	
	actor_animator = get_node(actor_animator_path)
	actor_mover = get_node(actor_mover_path)
	actor_transitioner = get_node(actor_transitioner_path)
	
	actor_animator.init(story_director)
	actor_mover.init(story_director)
	actor_transitioner.init(story_director)
	
	actor_transitioner.connect("transition_finished", self, "_on_transition_finished")
	

func get_actor_animator():
	return actor_animator


func get_actor_mover():
	return actor_mover


func get_actor_transitioner():
	return actor_transitioner


func get_actor():
	return actor


func _on_transition_finished(skipped):
	# Transfer visiblity from the node onto the real node, since
	# it's visiblity was determined by the hide or show transition
	visible = node_holder.visible
	node_holder.visible = true


# ----- Serialization ----- #

# actor_controller_serializer.gd

# ----- Serialization ----- #
