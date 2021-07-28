class_name StoryScriptTransition, "res://addons/FracturalVNE/assets/icons/transition.svg"
extends Node2D
# Responsible for transitioning from one Node2D to another Node2D.
# Base class for all Transitions.


# ----- Typeable ----- #

func is_type(type: String) -> bool:
	return get_types().has(type)

static func get_types() -> Array:
	return ["StoryScriptTransition"]

# ----- Typeable ----- #


signal transition_finished(skipped)

enum TransitionType {
	NONE,
	SHOW,
	HIDE,
	REPLACE,
}

export var show_transition_path: NodePath
export var hide_transition_path: NodePath
export var replace_transition_path: NodePath

var new_node: Node2D
var old_node: Node2D
var duration: float
var transition_type: int = TransitionType.NONE

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)
onready var replace_transition = get_node(replace_transition_path)


func _ready():
	propagate_call("_post_ready")


func transition(new_node_: Node2D, old_node_: Node2D, duration_: float):
	if transition_type != TransitionType.NONE:
		return
	
	if new_node_ != null:
		new_node_.visible = false
	if old_node_ != null:
		old_node_.visible = false
	
	if new_node_ != null and old_node_ == null:
		show_transition(new_node_, duration)
	elif old_node_ != null and new_node_ == null:
		hide_transition(old_node_, duration)
	elif new_node_ != null and old_node_ != null:
		replace_transition(new_node_, old_node_, duration)
	else:
		push_error("Both new_node_ and old_node_ are null! No transition can be played.")


func show_transition(new_node_: Node2D, duration_: float):
	new_node = new_node_
	old_node = null
	duration = duration_
	
	show_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	show_transition.transition(new_node, duration)


func hide_transition(old_node_: Node2D, duration_: float):
	new_node = null
	old_node = old_node_
	duration = duration_
	
	hide_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	hide_transition.transition(old_node, duration)


func replace_transition(new_node_: Node2D, old_node_: Node2D, duration_: float):
	new_node = new_node_
	old_node = old_node_
	duration = duration_
	
	replace_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	replace_transition.transition(new_node, old_node, duration)


func _on_transition_finished(skipped):
	match transition_type:
		TransitionType.SHOW:
			show_transition.disconnect("transition_finished", self, "_on_transition_finished")
			new_node.visible = true
		TransitionType.HIDE:
			hide_transition.disconnect("transition_finished", self, "_on_transition_finished")
			old_node.visible = false
		TransitionType.REPLACE:
			replace_transition.disconnect("transition_finished", self, "_on_transition_finished")
			old_node.visible = false
			new_node.visible = true
	
	transition_type = TransitionType.NONE
	
	emit_signal("transition_finished", skipped)
	
	# TEMP HACK TO CLEAR TRANSITION
	queue_free()

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

#	[X] Use FracVNE.Utils.is_type(object, type) whenever you do a type check

#	[X] When saving, make StoryDirector skip all current actions before saving.

#	[X] Pause the world when the pause menu is up

#	[ ] Finish Scene TransitionTypement parsing

#	[ ] Add custom methods to create animations and scenes to make them look cleaner.
#		(Maybe add Animation(), Scene(), and Curve() functions similar to how visuals 
#		are loaded with Visual() and DynamicVisual()?).
#	[X] Make the objects returned by Visual to just hold data about a visual. This then allows developers to choose when they want to load in visuals and when to cache visuals instead of forcing users to always cache visuals (by making the object returned by Visual() the ACTUAL visual node).
#	[ ] Write a remove statement that can remove Visuals
#		Example syntax:
#			define bob = Visual(...)
#			show bob
#			remove bob 			# Deletes the VisualController
#	[ ] Follow the structure of Visuals and VisualControllers
#		and design Scenes to operate in a similar manner.
#		The remove statement should work with scene as well.
#	[ ]	Abstract type checking for StoryScript binded functions 
#		into the Block's function handling part. We would also
#		have to add an parameter in StoryScript.Param._init() to 
#		accept a type as a string. If this parameter is blank
#		then the StoryScript.Param will accept any type.  
#	[ ] Refactor Visual and Scene transitions to use the same universal transition class.
#	[ ]
