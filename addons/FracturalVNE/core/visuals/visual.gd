extends Reference


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["Visual"]

# ----- Typeable ----- #


var name: String


func _init(name_ = null):
	name = name_
