class_name FracVNE_Runnable_ChainBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_chain.svg"
extends "linkable_runnable_behaviour.gd"
# Has transitions as children and chains all of them consecutively on ready.


func _ready():
	for i in get_child_count() - 1:
		if "next_runnable" in get_child(i):
			get_child(i).next_runnable = get_child(i + 1)
		else:
			push_error("Child does not have next_runnable!")

func run(args = []):
	get_child(0).run()
	_finish(args)
