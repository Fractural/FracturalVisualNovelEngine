extends Node


export var show_transition_path: NodePath
export var hide_transition_path: NodePath

onready var show_transition = get_node(show_transition_path)
onready var hide_transition = get_node(hide_transition_path)
