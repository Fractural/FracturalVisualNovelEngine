extends "runnable_behaviour.gd"
# Runnable behaviour that can be chained with other runnable behaviours


export var next_runnable_path: NodePath

var next_runnable: Node


func _ready():
	if not next_runnable_path.is_empty():
		next_runnable = get_node(next_runnable_path)


func run(args = []):
	_finish(args)


func _finish(args = []):
	if next_runnable != null:
		next_runnable.run(args)
