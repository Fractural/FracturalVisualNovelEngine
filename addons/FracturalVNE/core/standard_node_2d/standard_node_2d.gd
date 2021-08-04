tool
extends CanvasItem
# Serves as a wrapper for all 2D-related nodes (Control and Node2D).


export var standard_position: Vector2 = Vector2.ZERO setget set_standard_position, get_standard_position
export var standard_scale: Vector2 = Vector2.ONE setget set_standard_scale, get_standard_scale
export var standard_rotation: float = 0 setget set_standard_rotation, get_standard_rotation

export var global_standard_position: Vector2 = Vector2.ZERO setget set_global_standard_position, get_global_standard_position
export var global_standard_scale: Vector2 = Vector2.ONE setget set_global_standard_scale, get_global_standard_scale
export var global_standard_rotation: float = 0 setget set_global_standard_rotation, get_global_standard_rotation


# ----- Global Positions ----- #

func set_global_standard_position(value):
	pass


func get_global_standard_position():
	pass


func set_global_standard_scale(value):
	pass


func get_global_standard_scale():
	pass


func set_global_standard_rotation(value):
	pass


func get_global_standard_rotation():
	pass

# ----- Global Positions ----- #


# ----- Local Positions ----- #

func set_standard_position(value):
	pass


func get_standard_position():
	pass


func set_standard_rotation(value):
	pass


func get_standard_rotation():
	pass


func set_standard_scale(value):
	pass


func get_standard_scale():
	pass

# ----- Local Positions ----- #
