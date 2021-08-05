extends "single_transition.gd"
# Shows a node with a curve


export var transition_curve: Curve
export var node_holder_path: NodePath

var time: float
var original_node_parent: Node

onready var node_holder = get_node(node_holder_path)


func _ready() -> void:
	set_process(false)


func _process(delta) -> void:
	if time < duration:
		time += delta
		var progress
		if transition_type == TransitionType.HIDE:
			progress = 1 - time / duration
		else:
			progress = time / duration
		_tick(transition_curve.interpolate(progress))
	else:
		_on_transition_finished(false)


func transition(node_: Node, duration_: float):
	if not _setup_transition(node_, duration_):
		return
	
	original_node_parent = FracVNE.Utils.reparent(node, node_holder)
	
	time = 0
	
	set_process(true)


func _tick(percentage):
	pass


func _final_tick(final_percentage):
	pass


func _on_transition_finished(skipped: bool) -> void:
	set_process(false)
	_final_tick(1 if transition_type == TransitionType.SHOW else 0)
	
	FracVNE.Utils.reparent(node, original_node_parent)
	
	._on_transition_finished(skipped)
