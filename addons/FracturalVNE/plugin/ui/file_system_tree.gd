extends Tree
# Simualtes a system tree (Except without the custom icons for files)


const FracUtils = FracVNE.Utils

var FAVORITES_ICON: Texture
var FOLDER_ICON: Texture
var DEFAULT_FILE_ICON: Texture

# Key: File extension of the file
# Value: Icon for the file (Texture)
var file_extension_to_icon: Dictionary = {}
var file_extensions: Array = []
var include_sub_dirs: bool = true
var search_string: String = ""
var directory


func _ready():
	columns = 1


func _post_setup_assets():
	refresh_tree()


func refresh_tree():
	clear()
	var favorites_item = create_item()
	favorites_item.set_text(0, "Favorites:")
	favorites_item.set_icon(0, FAVORITES_ICON)
	
	_add_tree_items_recursive(directory)
	
	var main_dir_item = create_item()
	main_dir_item.set_text(0, "Favorites:")
	main_dir_item.set_icon(0, DEFAULT_FILE_ICON)


func _get_file_icon(path: String):
	var extension = path.get_extension()
	if file_extension_to_icon.has(extension):
		return file_extension_to_icon[extension]
	return DEFAULT_FILE_ICON


func _can_show_item(item_name: String):
	if search_string == "":
		return true
	return item_name.find(search_string) > -1


func _try_add_file_item(path: String, parent_tree_item: TreeItem):
	var item_name = path.get_file()
	if _can_show_item(item_name):
		var tree_item = create_item()
		tree_item.set_text(0, item_name)
		tree_item.set_icon(0, _get_file_icon(path))
		return tree_item


func _try_add_directory_item(path: String, parent_tree_item: TreeItem):
	var item_name = path.get_base_dir()
	if _can_show_item(item_name):
		var tree_item = create_item()
		tree_item.set_text(0, item_name)
		tree_item.set_icon(0, FOLDER_ICON)
		return tree_item 


func _add_tree_items_recursive(dir: Directory, parent_tree_item: TreeItem = null):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			var subDir = Directory.new()
			subDir.open(path)
			subDir.list_dir_begin(true, false)
			var directory_item = _try_add_directory_item(path, parent_tree_item)
			
			if include_sub_dirs:
				_add_tree_items_recursive(subDir, directory_item)
		else:
			if file_extensions.empty():
				_try_add_file_item(path, parent_tree_item)
			else:
				# TODO DISCUSS: Maybe convert file_extensions to a hashtable if performance is necessary?
				for file_extension in file_extensions:
					if not Engine.is_editor_hint():
						# Only .import files are available in the exported builds,
						# therefore we have to look for those instead.
						path = path.trim_suffix(".import")
					if file_extension == path.get_extension():
						_try_add_file_item(path, parent_tree_item)
						break

		file_name = dir.get_next()

	dir.list_dir_end()


func _setup_editor_assets(assets_registry):
	FOLDER_ICON = assets_registry.load_asset("assets/icons/folder.svg")
	FAVORITES_ICON = assets_registry.load_asset("assets/icons/favorites.svg")
	DEFAULT_FILE_ICON = assets_registry.load_asset("assets/icons/file.svg")
	_post_setup_assets()
