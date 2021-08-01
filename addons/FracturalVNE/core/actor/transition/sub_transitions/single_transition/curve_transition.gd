extends "single_transition.gd"
# Shows a node with a curve


export var fade_curve: Curve
export var node_holder_path: NodePath

var time: float
var original_node_parent: Node

onready var node_holder = get_node(node_holder_path)


func _ready():
	set_process(false)


func _process(delta):
	if time < duration:
		time += delta
		var progress
		if transition_type == TransitionType.HIDE:
			progress = 1 - time / duration
		else:
			progress = time / duration
		_tick(fade_curve.interpolate(progress))
	else:
		_on_transition_finished(false)


func transition(node_: Node, duration_: float):
	if not .transition(node_, duration_):
		return false
	
	original_node_parent = node.get_parent()
	var original_parent_path = original_node_parent.get_path()
	FracVNE.Utils.reparent(node, node_holder)
	
	time = 0
	
	set_process(true)
	return true


func _tick(percentage):
	pass


func _final_tick(final_percentage):
	pass


func _on_transition_finished(skipped):
	set_process(false)
	_final_tick(1 if transition_type == TransitionType.SHOW else 0)
	
	var original_parent_path = original_node_parent.get_path()
	FracVNE.Utils.reparent(node, original_node_parent)
	
	._on_transition_finished(skipped)
