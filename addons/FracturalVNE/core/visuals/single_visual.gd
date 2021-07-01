extends "visual.gd"


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("SingleVisual")
	return arr

# ----- Typeable ----- #


var texture: Texture


func _init(texture_ = null, name_ = null).(name_):
	texture = texture_
