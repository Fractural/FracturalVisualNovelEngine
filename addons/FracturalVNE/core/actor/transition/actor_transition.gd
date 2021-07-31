class_name FracVNE_ActorTransition, "res://addons/FracturalVNE/assets/icons/transition.svg"
extends Node2D
# Responsible for transitioning from one Node2D to another Node2D.
# Base class for all Transitions.

# TODO: Refactor ActorTransition to a Resource file that points
#		to the respective transition classes for  
#		ShowNode2D
#		HideNode2D
#		ReplaceNode2D
#		ShowControl
#		HideControl
#		ReplaceControl
#
# NOTE: We have to have a unique transition for Control vs. Node2D
#		Since the two types have different names for their position variables
#		(Node2D uses position while Control uses rect_position)


# ----- Typeable ----- #
func get_types() -> Array:
	return ["ActorTransition"]

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

# Controls the compatibility of this transition
# Normally transitions that modify position using animations
# TODO: CrossFade and FadeToColor are technically not compliant
#		with Control nodes since they use Node2D for their holder
#		How would a single node achieve cross compatability? 
#		It's impossible!
export var is_control_compatible: bool = true
export var is_node_2d_compatible: bool = true

var transition_type: int = TransitionType.NONE

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)
onready var replace_transition = get_node(replace_transition_path)


func _ready():
	propagate_call("_post_ready")


func is_compatible(node: Node):
	if (not node is CanvasItem 
		or (node is Node2D and not is_node_2d_compatible) 
		or (node is Control and not is_control_compatible)):
		return false
	return true


func transition(new_node: Node, old_node: Node, duration: float):
	if not is_compatible(new_node) or not is_compatible(old_node) or transition_type != TransitionType.NONE:
		return
	
	if new_node != null:
		new_node.visible = false
	if old_node != null:
		old_node.visible = false
	
	if new_node != null and old_node == null:
		show_transition(new_node, duration)
	elif old_node != null and new_node == null:
		hide_transition(old_node, duration)
	elif new_node != null and old_node != null:
		replace_transition(new_node, old_node, duration)
	else:
		push_error("Both new_node and old_node are null! No transition can be played.")


func show_transition(new_node: Node, duration: float):
	if not is_compatible(new_node) or transition_type != TransitionType.NONE:
		return
	new_node.visible = true
	transition_type = TransitionType.SHOW
	show_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	show_transition.transition(new_node, duration)


func hide_transition(old_node: Node, duration: float):
	if not is_compatible(old_node) or transition_type != TransitionType.NONE:
		return
	old_node.visible = true
	transition_type = TransitionType.HIDE
	hide_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	hide_transition.transition(old_node, duration)


func replace_transition(new_node: Node, old_node: Node, duration: float):
	if not is_compatible(new_node) or not is_compatible(old_node) or transition_type != TransitionType.NONE:
		return
	new_node.visible = true
	old_node.visible = true
	transition_type = TransitionType.REPLACE
	replace_transition.connect("transition_finished", self, "_on_transition_finished", [false])
	replace_transition.transition(new_node, old_node, duration)


func _on_transition_finished(skipped):
	match transition_type:
		TransitionType.SHOW:
			# We disconnnect the transition_finished signal first to prevent a second transition_finished 
			# from firing here after we call _on_transition_finished() on the sub transition.
			show_transition.disconnect("transition_finished", self, "_on_transition_finished")
			if skipped:
				show_transition._on_transition_finished(skipped)
		TransitionType.HIDE:
			hide_transition.disconnect("transition_finished", self, "_on_transition_finished")
			if skipped:
				hide_transition._on_transition_finished(skipped)
		TransitionType.REPLACE:
			replace_transition.disconnect("transition_finished", self, "_on_transition_finished")
			if skipped:
				replace_transition._on_transition_finished(skipped)
	transition_type = TransitionType.NONE
	
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
#	[ ]	Add type checking for StoryScript binded functions 
#		into the Block's function handling part. We would also
#		have to add an parameter in StoryScript.Param._init() to 
#		accept a type as a string. If this parameter is blank
#		then the StoryScript.Param will accept any type.  
#	[X] Refactor Visual and Scene transitions to use the same universal transition class.
#	[ ]
