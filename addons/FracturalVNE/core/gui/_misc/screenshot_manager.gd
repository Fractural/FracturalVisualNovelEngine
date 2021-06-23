extends Node

signal finished_screenshot(screenshot)

export var temporary_viewport_texture_rect_path: NodePath
export var story_gui_configurer_path: NodePath
export var gui_viewport_path: NodePath

onready var temporary_viewport_texture_rect = get_node(temporary_viewport_texture_rect_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var gui_viewport = get_node(gui_viewport_path)

var screenshot

# HACK: Entire screenshot method is a disgusting mess of reparenting due to Godot's
# 		terrible support for viewports. (ie. viewports not receiving unhandled_input, 
#		etc)
func screenshot():
	# Reparent the gui as a child of the viewport
	story_gui_configurer.story_gui_holder.remove_child(story_gui_configurer.story_gui)
	gui_viewport.add_child(story_gui_configurer.story_gui)
	
	# Create a screenshot of the entire view before performing the actual screenshot.
	# This preliminary screenshot will be pasted over the screen in another viewport
	# while the real screenshot is taken.
	var img = get_viewport().get_texture().get_data()
	# Flip on the Y axis.
	# You can also set "V Flip" to true if not on the root Viewport.
	img.flip_y()
	# Convert Image to ImageTexture.
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	temporary_viewport_texture_rect.texture = tex
	temporary_viewport_texture_rect.visible = true
	
	yield(get_tree(), "idle_frame")

	var original_pause_menu_visibility
	if story_gui_configurer.story_gui.pause_menu != null:
		original_pause_menu_visibility = story_gui_configurer.story_gui.pause_menu.visible
		story_gui_configurer.story_gui.pause_menu.visible = false

	yield(get_tree(), "idle_frame")

	var viewport_texture_image = gui_viewport.get_texture().get_data()
	viewport_texture_image.flip_y()
	viewport_texture_image.resize(512, 512 * viewport_texture_image.get_height() / viewport_texture_image.get_width())

	var viewport_texture = ImageTexture.new()
	viewport_texture.create_from_image(viewport_texture_image)

	if story_gui_configurer.story_gui.pause_menu != null:
		story_gui_configurer.story_gui.pause_menu.visible = original_pause_menu_visibility

	# Take down the temporary viewport texture
	temporary_viewport_texture_rect.visible = false
	temporary_viewport_texture_rect.texture = null
	
	screenshot = viewport_texture
	
	# Move the gui outside of the viewport to it's original place
	gui_viewport.remove_child(story_gui_configurer.story_gui)
	story_gui_configurer.story_gui_holder.add_child(story_gui_configurer.story_gui)
	
	emit_signal("finished_screenshot", screenshot)
