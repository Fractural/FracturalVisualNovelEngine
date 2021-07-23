extends Node
# Base class for all visual animations


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["VisualAnimation"]

# ----- Typeable ----- #


signal animation_finished(skipped)

var visual_holder


func animate(visual_holder_):
	visual_holder = visual_holder_


func _on_animation_finished(skipped):
	emit_signal("animation_finished", skipped)
