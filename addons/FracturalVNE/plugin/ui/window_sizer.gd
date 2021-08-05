extends Node
# Makes the standalone editor go to full-screen immediately.
# This is useful for Hi-DPI screens since the window will be tiny
# otherwise when opened from the editor.


func _ready() -> void:
	var dpi = OS.get_screen_dpi(OS.get_current_screen())
	OS.window_size = OS.window_size * (dpi / 100.0)
