extends Node
# Base class for scene transitions


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["SceneTransition"]

# ----- Typeable ----- #


signal transition_finished(skipped)

var new_scene: Node
var old_scene: Node
var duration: float
var curr_scene_transition_action


func transition(new_scene_: Node, old_scene_: Node, duration_: float):
	new_scene = new_scene_
	old_scene = old_scene_
	duration = duration_


func _on_transition_finished(skipped):
	old_scene.visible = false
	new_scene.visible = true
	
	emit_signal("transition_finished", skipped)


# TODO NOW: 
#	[X]	Add a fade to black scene transition
#	[X]	Add a crossfade transition

#	[X]	Refactor animate, show, and hide statements to all use
#		a dedicated object for each animation similar to how
#		scene_transition works for scene_manager.

#		[X]	Show and hide could use a visual_transition.gd class
#		[X]	Animate could use an animate.gd class

#	[ ]	Add global constants such as:

#	[ ]	PosLeft and PosRight to represent Vector2 on right and left side of
#		the screen. These constants could then be used in move statements.

#	[ ] Use FracVNE.Utils.is_type(object, type) whenever you do a type check

#	[X] When saving, make StoryDirector skip all current actions before saving.

#	[X] Pause the world when the pause menu is up

#	[ ] Finish Scene Statement parsing

#	[ ] Add custom methods to create animations and visuals to make them look cleaner.
#		(Maybe add Animation(), Scene(), and Curve() functions similar to how visuals 
#		are loaded with Visual() and DynamicVisual()?).
