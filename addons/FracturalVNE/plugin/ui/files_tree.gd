tool
extends Tree
# Makes a tree of files


signal file_selected(file_path)

export var default_file_icon: Texture
export var favorites_cion: Texture
export var folder_icon: Texture

export var file_extensions: Array = []
export var include_sub_dirs: bool = true
export var search_text: String = ""
export var directory: String

# Key: File extension of the file
# Value: Icon for the file (Texture)
var file_extension_to_icon: Dictionary = {}
var tree_items: Array = []

var _folder_count = 0


func _ready():
	columns = 1
	connect("cell_selected", self, "_on_cell_selected")


func clear():
	.clear()


func select_file(selected_file_path):
	for tree_item in tree_items:
		if tree_item.get_metadata(0) == selected_file_path:
			tree_item.select(0)
			break
		tree_item.deselect(0)


func refresh(selected_file_path: String = ""):
	# Key: Path to file
	# Value: Was the file collapsed
	var collapsed_items: Dictionary = {}
	for item in tree_items:
		if item.collapsed:
			collapsed_items[item.get_metadata(0).path] = null
	
	clear()
	tree_items = []
	
	var root = create_item()
	set_hide_root(true)
		
	if directory != "":
		var directory_item = _try_add_directory_item(directory, selected_file_path, root)
		_start_add_tree_items_recursive(directory, selected_file_path, directory_item)
	
	for item in tree_items:
		if collapsed_items.has(item.get_metadata(0).path):
			item.collapsed = true
	
	var favorites_item = create_item(root, 0)
	favorites_item.set_text(0, "Favorites:")
	favorites_item.set_icon(0, favorites_cion)


func _on_cell_selected():
	if get_selected().get_metadata(0).type == "file":
		emit_signal("file_selected", get_selected().get_metadata(0))


func _get_file_icon(path: String):
	var extension = path.get_extension()
	if file_extension_to_icon.has(extension):
		return file_extension_to_icon[extension]
	return default_file_icon


func _can_show_item(item_name: String):
	if search_text == "":
		return true
	return item_name.find(search_text) > -1


func _try_add_file_item(path: String, selected_file_path: String, parent_tree_item: TreeItem = null):
	return _build_basic_item(path, path.get_file(), _get_file_icon(path), "file", selected_file_path, parent_tree_item)


func _try_add_directory_item(path: String, selected_file_path: String, parent_tree_item: TreeItem = null):
	_folder_count += 1
	return _build_basic_item(path, path.get_file(), folder_icon, "folder", selected_file_path, parent_tree_item, _folder_count - 1)


func _build_basic_item(path: String, item_name: String, icon: Texture, type: String, selected_file_path: String, parent_tree_item: TreeItem, child_number: int = -1):
	if _can_show_item(item_name):
		var tree_item = create_item(parent_tree_item, child_number)
		tree_item.set_text(0, item_name)
		tree_item.set_icon(0, icon)
		tree_item.set_metadata(0, { "path": path, "type": type })
		tree_items.append(tree_item)
		if selected_file_path == path:
			tree_item.select(0)
		return tree_item 


func _start_add_tree_items_recursive(root_path: String, selected_file_path: String = "", parent_tree_item: TreeItem = null):
	_folder_count = 0
	var dir = Directory.new()

	if dir.open(root_path) == OK:
		dir.list_dir_begin(true, false)
		_add_tree_items_recursive(dir, selected_file_path, parent_tree_item)
	else:
		push_warning("An error occurred when trying to access the path.")


func _add_tree_items_recursive(dir: Directory, selected_file_path: String = "", parent_tree_item: TreeItem = null):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			var directory_item = _try_add_directory_item(path, selected_file_path, parent_tree_item)
			
			if include_sub_dirs:
				_add_tree_items_recursive(subDir, selected_file_path, directory_item)
		else:
			if file_extensions.empty():
				_try_add_file_item(path, selected_file_path, parent_tree_item)
			else:
				# TODO DISCUSS: Maybe convert file_extensions to a hashtable if performance is necessary?
				for file_extension in file_extensions:
					if not Engine.is_editor_hint():
						# Only .import files are available in the exported builds,
						# therefore we have to look for those instead.
						path = path.trim_suffix(".import")
					if file_extension == path.get_extension():
						_try_add_file_item(path, selected_file_path, parent_tree_item)
						break

		file_name = dir.get_next()

	dir.list_dir_end()
