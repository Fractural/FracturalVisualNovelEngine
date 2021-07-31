extends "res://addons/FracturalVNE/core/actor/transition/sub_transitions/single_transition/curve_transition.gd"
# Fades a node in or out.


func _tick(percentage):
	node_holder.modulate.a = percentage


func _final_tick(final_percentage):
	node_holder.modulate.a = final_percentage
