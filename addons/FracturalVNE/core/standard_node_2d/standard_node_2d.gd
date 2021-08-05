extends CanvasItem
# Serves as a wrapper for all 2D-related nodes (Control and Node2D).


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StandardNode2D"]

# ----- Typeable ----- #



export var standard_position: Vector2 = Vector2.ZERO setget set_standard_position, get_standard_position
export var standard_scale: Vector2 = Vector2.ONE setget set_standard_scale, get_standard_scale
export var standard_rotation: float = 0 setget set_standard_rotation, get_standard_rotation

export var global_standard_position: Vector2 = Vector2.ZERO setget set_global_standard_position, get_global_standard_position
export var global_standard_scale: Vector2 = Vector2.ONE setget set_global_standard_scale, get_global_standard_scale
export var global_standard_rotation: float = 0 setget set_global_standard_rotation, get_global_standard_rotation


# ----- Global Positions ----- #

func set_global_standard_position(value):
	if is_inside_tree():
		match get_class():
			"Control":
				self.rect_global_position = value
			"Node2D":
				self.global_position = value


func get_global_standard_position():
	if is_inside_tree():
		match get_class():
			"Control":
				return self.rect_global_position
			"Node2D":
				return self.global_position


func set_global_standard_scale(value):
	if is_inside_tree():
		match get_class():
			"Control":
				# Not sure how to access global scale for
				# Controls yet...
				self.rect_scale = value
			"Node2D":
				self.global_scale = value


func get_global_standard_scale():
	if is_inside_tree():
		match get_class():
			"Control":
				return self.rect_scale
			"Node2D":
				return self.global_scale


func set_global_standard_rotation(value):
	if is_inside_tree():
		match get_class():
			"Control":
				# Not sure how to access global rotation
				# for Controls yet...
				self.rect_rotation = value
			"Node2D":
				self.global_rotation = value


func get_global_standard_rotation():
	if is_inside_tree():
		match get_class():
			"Control":
				return self.rect_rotation
			"Node2D":
				return self.global_rotation

# ----- Global Positions ----- #


# ----- Local Positions ----- #

func set_standard_position(value):
	match get_class():
		"Control":
			self.rect_position = value
		"Node2D":
			self.position = value


func get_standard_position():
	match get_class():
		"Control":
			return self.rect_position
		"Node2D":
			return self.position


func set_standard_rotation(value):
	match get_class():
		"Control":
			self.rect_rotation = value
		"Node2D":
			self.rotation = value


func get_standard_rotation():
	match get_class():
		"Control":
			return self.rect_rotation
		"Node2D":
			return self.rotation


func set_standard_scale(value):
	match get_class():
		"Control":
			self.rect_scale = value
		"Node2D":
			self.scale = value


func get_standard_scale():
	match get_class():
		"Control":
			return self.rect_scale
		"Node2D":
			return self.scale

# ----- Local Positions ----- #
