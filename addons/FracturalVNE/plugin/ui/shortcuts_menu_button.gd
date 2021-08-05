tool
extends MenuButton


signal menu_item_pressed(meta)


func _ready() -> void:
	get_popup().connect("id_pressed", self, "_on_popup_id_pressed")


func create_separator():
	get_popup().add_separator()


func create_shortcut(label: String, meta, scancode: int, other_keys: Array = []):
	var popup = get_popup()
	
	var ev = InputEventKey.new()
	ev.scancode = scancode
	ev.meta = false
	if OS.get_name() == "OSX":
		ev.command = other_keys.has("ctrl")
	else:
		ev.control = other_keys.has("ctrl")
	ev.alt = other_keys.has("alt")
	ev.shift = other_keys.has("shift")
	
	var shortcut = ShortCut.new()
	shortcut.resource_name = label
	shortcut.shortcut = ev
	
	popup.add_shortcut(shortcut)

	popup.set_item_metadata(popup.get_item_count() - 1, meta)


func _on_popup_id_pressed(idx):
	var popup = get_popup()
	var meta = popup.get_item_metadata(idx)
	emit_signal("menu_item_pressed", meta)
