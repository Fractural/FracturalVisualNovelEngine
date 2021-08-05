extends Node

func _ready() -> void:
	$TextReveal.start_reveal()
	yield(get_tree().create_timer(5.0), "timeout")
	$TextReveal.start_reveal()
