class_name FracVNE_Runnable_ParallelBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_branch.svg"
extends "linkable_runnable_behaviour.gd"
# Like a branch except it operates on it's children


func run(args = []):
	for child in get_children():
		child.run()
	_finish(args)
