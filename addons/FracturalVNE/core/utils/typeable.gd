extends Reference

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return []
