extends "res://addons/FracturalVNE/core/actor/transition/sub_transitions/single_transition/curve_transition.gd"
# Fades a node to or out of a color.


func _tick(percentage):
	# We have to do 1 - percentage since 0 tint amount means the node is visible.
	node_holder.material.set_shader_param("tint_amount", 1 - percentage)


func _final_tick(final_percentage):
	node_holder.material.set_shader_param("tint_amount", 1 - final_percentage)
