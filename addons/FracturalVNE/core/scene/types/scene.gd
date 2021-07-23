extends Node
# Base class for all scenes


# ----- Typeable ----- #

func is_type(type):
	return get_types().has(type)


func get_types():
	return ["BGScene"]

# ----- Typeable ----- #
