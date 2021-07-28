class_name FracVNE_Runnable_TimerIteratorBehaviour, "res://addons/FracturalVNE/assets/icons/runnable_timer_iterator.svg"
extends "linkable_runnable_behaviour.gd"
# Calls run on iterated_runnable every frame for a duration.


export var iterated_runnable_path: NodePath 
export var duration_path: NodePath
export var percentage_path: NodePath

var time: float
var args

onready var iterated_runnable = get_node(iterated_runnable_path)
onready var duration = get_node(duration_path)
onready var percentage = get_node(percentage_path)


func _ready():
	set_process(false)


func _process(delta):
	if time < duration.value:
		time += delta
		percentage.value = time / duration.value
		iterated_runnable.run(args)
	else:
		set_process(false)
		_finish(args)


func run(args_ = []):
	args = args_
	set_process(true)
		
	time = 0
