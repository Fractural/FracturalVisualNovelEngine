class_name FracVNE_Runnable_BranchBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_branch.svg"
extends "res://addons/FracturalVNE/core/runnable_behaviour/linkable_runnable_behaviour.gd"
# A behaviour that can be finished. This works in tandem with RunnableBehaviour.


export(Array, NodePath) var next_runnable_paths: Array = []


func run(args = []):
	for runnable_path in next_runnable_paths:
		get_node(runnable_path).listener.run(args)
	_finish(args)
