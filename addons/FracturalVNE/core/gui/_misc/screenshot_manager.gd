extends Node
# A service that can take screenshots at runtime


# Since taking screenshots takes time, the process is asynchronous
# and finished_screenshot() get called when the service finishes taking
# a screenshot.
signal finished_screenshot(screenshot)

export var facade_viewport_texture_rect_path: NodePath
export var story_gui_configurer_path: NodePath
export var gui_viewport_path: NodePath

# The latest screenshot taken
var screenshot

onready var facade_viewport_texture_rect = get_node(facade_viewport_texture_rect_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var gui_viewport = get_node(gui_viewport_path)


# Screenshots the entire screen
func screenshot():
	var image = get_viewport().get_texture().get_data()
	
	image.flip_y()
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	screenshot = texture
	emit_signal("finished_screenshot", texture)

# Screenshots all gameplay related nodes (excludes pause menu).

# HACK: Entire screenshot method is a disgusting mess of reparenting due to Godot's
# 		terrible support for viewports. (ie. viewports not receiving unhandled_input, 
#		etc)
func screenshot_gameplay():
	# Reparent the gui as a child of the viewport
	story_gui_configurer.story_gui_holder.remove_child(story_gui_configurer.story_gui)
	gui_viewport.add_child(story_gui_configurer.story_gui)
	
	# Create a screenshot of the entire view before performing the actual screenshot.
	# This preliminary screenshot will be pasted over the screen in another viewport
	# while the real screenshot is taken.
	var facade_image = get_viewport().get_texture().get_data()
	
	# Flip the Y axis since the viewport texture is actually flipped vertically..
	facade_image.flip_y()
	
	# Convert Image to ImageTexture.
	var facade_texture = ImageTexture.new()
	facade_texture.create_from_image(facade_image)
	
	facade_viewport_texture_rect.texture = facade_texture
	facade_viewport_texture_rect.visible = true
	
	yield(get_tree(), "idle_frame")

	var original_pause_menu_visibility
	if story_gui_configurer.story_gui.pause_menu != null:
		original_pause_menu_visibility = story_gui_configurer.story_gui.pause_menu.visible
		story_gui_configurer.story_gui.pause_menu.visible = false

	yield(get_tree(), "idle_frame")

	var viewport_texture_image = gui_viewport.get_texture().get_data()
	viewport_texture_image.flip_y()

	var viewport_texture = ImageTexture.new()
	viewport_texture.create_from_image(viewport_texture_image)

	if story_gui_configurer.story_gui.pause_menu != null:
		story_gui_configurer.story_gui.pause_menu.visible = original_pause_menu_visibility

	# Take down the temporary viewport texture
	facade_viewport_texture_rect.visible = false
	facade_viewport_texture_rect.texture = null
	
	# Move the gui outside of the viewport to it's original place
	gui_viewport.remove_child(story_gui_configurer.story_gui)
	story_gui_configurer.story_gui_holder.add_child(story_gui_configurer.story_gui)
	
	screenshot = viewport_texture
	emit_signal("finished_screenshot", screenshot)
