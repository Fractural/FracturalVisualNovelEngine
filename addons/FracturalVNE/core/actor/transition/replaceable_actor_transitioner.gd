extends "res://addons/FracturalVNE/core/actor/transition/actor_transitioner.gd"
# Allows for transitions that replaces the visual of an actor


# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("ReplaceableActorTransitioner")
	return arr

# ----- Typeable ----- #


export var old_node_holder_path: NodePath

onready var old_node_holder = get_node(old_node_holder_path)


func _ready():
	_set_old_holder_visibility(false)


func replace(transition = null, duration = 1):
	_finish_current_transition()
	
	if transition != null:
		_setup_new_transition(TransitionType.REPLACE, transition)
		transition.transition(actor_holder, old_node_holder, duration)
	else:
		_set_old_holder_visibility(false)
		_set_actor_visibility(true)


func _set_old_holder_visibility(value):
	old_node_holder.visible = value


func _on_transition_finished(skipped):
	_set_old_holder_visibility(false)
	._on_transition_finished(skipped)
