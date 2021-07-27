extends Node


# ----- Typeable ----- #

static func get_types() -> Array:
	var arr = .get_types()
	arr.append("ShowHide")
	return arr

# ----- Typeable ----- #


enum TransitionType {
	SHOW,
	HIDE
}

export var single_transition_path: NodePath
export(TransitionType) var transition_type: int = TransitionType.SHOW

onready var single_transition = get_node(single_transition_path)


func _on_transition():
	single_transition.node.visible = true


func _on_transition_finished():
	if transition_type == TransitionType.HIDE:
		single_transition.node.visible = false


func _on_Hide_hide():
	pass # Replace with function body.
