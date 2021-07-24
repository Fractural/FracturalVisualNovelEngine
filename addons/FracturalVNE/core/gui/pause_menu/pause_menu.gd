extends Control
# Manages the visibility of the pause menu and handles
# requests to open the pause menu while simultaneously navigating to 
# a specific section.  


export var menu_manager_path: NodePath
export var save_slots_menu_path: NodePath

onready var menu_manager = get_node(menu_manager_path)
onready var save_slots_menu = get_node(save_slots_menu_path)


func toggle(enabled):
	visible = enabled
	# BUG: 	According to https://github.com/godotengine/godot/issues/41643,
	#		Godot currently has a memory leak if you make any inputs while
	#		the scene_tree is paused. I can't do anything about this now but
	#		maybe sometime in the future it can get fixed.
	#		From average use this leaks about 0.01 MiB or 10 KB of memory
	#	EDIT:	Pausing only causes memory increases while pausing is
	#			enabled. This is not the source of the 0.01 MiB memory leak.	 
	#get_tree().paused = enabled


func show_options():
	toggle(true)
	menu_manager.goto_menu("Options")


func show_save():
	toggle(true)
	save_slots_menu.start_save()


func show_load():
	toggle(true)
	save_slots_menu.start_load()


func show_history():
	toggle(true)
	menu_manager.goto_menu("History")


func _get_property_list():
    var properties = []
    properties.append({
            name = "Rotate",
            type = TYPE_NIL,
            hint_string = "rotate_",
            usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
    })
    return properties
