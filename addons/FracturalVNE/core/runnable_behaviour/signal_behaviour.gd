class_name FracVNE_Runnable_SignalBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_signal.svg"
extends "runnable_behaviour.gd"


signal on_run(args)


func run(args = []):
	emit_signal("on_run", args)
