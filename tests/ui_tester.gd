extends Node
# Holds functions used for testing UI components.


func simulate_click(position: Vector2):
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.position = position
	a.pressed = true
	Input.parse_input_event(a)
