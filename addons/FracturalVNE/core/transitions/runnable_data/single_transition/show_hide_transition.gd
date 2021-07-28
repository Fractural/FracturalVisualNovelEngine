extends Node


enum TransitionType {
	SHOW,
	HIDE
}

export var single_transition_path: NodePath
export(TransitionType) var transition_type: int = TransitionType.SHOW
