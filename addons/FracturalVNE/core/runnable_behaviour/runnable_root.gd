extends "runnable.gd"
# Runnable behaviour that can serve as the start of a runnable tree


export var runnable_path: NodePath

onready var runnable = get_node(runnable_path)
