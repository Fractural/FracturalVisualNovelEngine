extends Viewport

func _ready():
	get_tree().root.connect("size_changed", self, "_on_main_viewport_size_changed")
	size = get_tree().root.size

func _on_main_viewport_size_changed():
	size = get_tree().root.size
