extends Panel
# Manages a single panel menu by making the current active panel
# visible and all other panels invisible. 


export var menu_title_path: NodePath

onready var menu_title: Label = get_node(menu_title_path)


func _ready():
	goto_menu(get_child(0).name)


func goto_menu(menu_name: String, menu_title_text = null):
	for child in get_children():
		child.visible = child.name == menu_name
	if typeof(menu_title_text) == TYPE_STRING:
		menu_title.text = menu_title_text
	else:
		menu_title.text = menu_name
