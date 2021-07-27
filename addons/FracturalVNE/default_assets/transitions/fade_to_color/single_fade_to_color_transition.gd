extends "res://addons/FracturalVNE/core/transitions/single_show_hide_transition.gd"
# Scene transition that crossfades between two scenes


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("FadeToColorTransition")
	return arr

# ----- Typeable ----- #


export var fade_curve: Curve
export var node_holder_path: NodePath

var time: float
var node_original_parent: Node

onready var node_holder = get_node(node_holder_path)


func _ready():
	# duplicate(true) duplicates all children as well, which includes the 
	# tint shader attached to the material.
	node_holder.material = node_holder.material.duplicate(true)


func _process(delta):
	if time < duration:
		time += delta
		node_holder.material.set_shader_param("tint_amount", fade_curve.interpolate(time / duration))
	else:
		set_process(false)
		_on_transition_finished()


func _transition():
	set_process(true)
	
	node_original_parent = node.get_parent()
	FracVNE.Utils.reparent(node, node_holder)
	
	time = 0


func _on_transition_finished():
	FracVNE.Utils.reparent(node, node_original_parent)
	
	._on_transition_finished()
