extends Node
# -- Abstract Class -- #
# Base class for all StandardNode2DAnimations.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["NodeAnimation"]

# ----- Typeable ----- #


signal animation_finished(skipped)

var visual_holder


func animate(visual_holder_):
	visual_holder = visual_holder_


func _on_animation_finished(skipped):
	emit_signal("animation_finished", skipped)
