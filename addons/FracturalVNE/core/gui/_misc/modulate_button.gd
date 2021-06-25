tool
extends Button
# Button that changes color depending on its state 
# (normal, hovered, pressed, disabled).


export var normal_color: Color = Color.white
export var disabled_color: Color = Color.white
export var pressed_color: Color = Color.white
export var hover_color: Color = Color.white


func _draw():
	match get_draw_mode():
		DRAW_NORMAL:
			modulate = normal_color
		DRAW_DISABLED:
			modulate = disabled_color
		DRAW_PRESSED, DRAW_HOVER_PRESSED:
			modulate = pressed_color
		DRAW_HOVER:
			modulate = hover_color
