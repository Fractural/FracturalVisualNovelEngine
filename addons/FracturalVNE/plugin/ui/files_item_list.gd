tool
extends ItemList
# Makes an item list of files.


signal file_selected(file_path)

const FracUtils = FracVNE.Utils

export var default_file_icon: Texture

export var file_extensions: Array = []
export var include_sub_dirs: bool = true
export var search_text: String = ""
export var directory: String

# Key: File extension of the file
# Value: Icon for the file (Texture)
var file_extension_to_icon: Dictionary = {}


func _ready():
	connect("item_selected", self, "_on_item_selected")


func select_file(selected_file_path: String = ""):
	# 4.0 support. See https://github.com/godotengine/godot/pull/44569.
	#if Engine.get_version_info().major >= 4.0:
	#	deselect_all()
	#else:
	unselect_all()
	for i in get_item_count():
		if get_item_metadata(i) == selected_file_path:
			select(i, true)
			break


func clear():
	.clear()


func refresh(selected_file_path: String = ""):
	clear()
	
	# sort() does an alphabetical string sort.
	var file_paths = FracUtils.get_dir_files(directory, include_sub_dirs, file_extensions)
	file_paths.sort()
	for file_path in file_paths:
		var file_name = file_path.get_file()
		if _can_show_item(file_name):
			add_item(file_name, _get_file_icon(file_path))
			set_item_metadata(get_item_count() - 1, file_path)	
			if selected_file_path == file_path:
				select(get_item_count() - 1, true)


func _get_file_icon(path: String):
	var extension = path.get_extension()
	if file_extension_to_icon.has(extension):
		return file_extension_to_icon[extension]
	return default_file_icon


func _can_show_item(item_name: String):
	if search_text == "":
		return true
	return item_name.find(search_text) > -1


func _on_item_selected(index: int):
	emit_signal("file_selected", get_item_metadata(index))
