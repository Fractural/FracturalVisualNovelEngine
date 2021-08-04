tool
extends "res://addons/FracturalVNE/core/standard_node_2d/standard_node_2d.gd"
# Serves as a wrapper for all 2D-related nodes (Control and Node2D).

# TODO: Figure out how to set and get global scale and rotation
# 		for Control nodes.


# ----- Global Positions ----- #

func set_global_standard_position(value):
	if is_inside_tree():
		self.rect_global_position = value


func get_global_standard_position():
	if is_inside_tree():
		return self.rect_global_position


func set_global_standard_scale(value):
	if is_inside_tree():
		# Not sure how to set global_scale...
		# Needs more research...
		self.rect_scale = value


func get_global_standard_scale():
	if is_inside_tree():
		return self.rect_scale


func set_global_standard_rotation(value):
	if is_inside_tree():
		# Not sure how to set global_rotaion...
		# Needs more research...
		self.rect_rotation = value


func get_global_standard_rotation():
	if is_inside_tree():
		return self.rect_rotation

# ----- Global Positions ----- #


# ----- Local Positions ----- #

func set_standard_position(value):
	self.rect_position = value


func get_standard_position():
	return self.rect_position


func set_standard_rotation(value):
	# Assuming rotation doesn't pass down the tree
	# for Control nodes. Needs testing...
	self.rect_rotation = value


func get_standard_rotation():
	return self.rect_rotation


func set_standard_scale(value):
	# Assuming scale doesn't pass down the tree
	# for Control nodes. Needs testing...
	self.rect_scale = value


func get_standard_scale():
	return self.rect_scale

# ----- Local Positions ----- #
