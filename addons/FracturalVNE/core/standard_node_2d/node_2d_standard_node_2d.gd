tool
extends "res://addons/FracturalVNE/core/standard_node_2d/standard_node_2d.gd"
# Serves as a wrapper for all 2D-related nodes (Control and Node2D).


# ----- Global Positions ----- #

func set_global_standard_position(value):
	if is_inside_tree():
		self.global_position = value


func get_global_standard_position():
	if is_inside_tree():
		return self.global_position


func set_global_standard_scale(value):
	if is_inside_tree():
		self.global_scale = value


func get_global_standard_scale():
	if is_inside_tree():
		return self.global_scale


func set_global_standard_rotation(value):
	if is_inside_tree():
		self.global_rotation = value


func get_global_standard_rotation():
	if is_inside_tree():
		return self.global_rotation

# ----- Global Positions ----- #


# ----- Local Positions ----- #

func set_standard_position(value):
	self.position = value


func get_standard_position():
	return self.position


func set_standard_rotation(value):
	self.rotation = value


func get_standard_rotation():
	return self.rotation


func set_standard_scale(value):
	self.scale = value


func get_standard_scale():
	return self.scale

# ----- Local Positions ----- #
