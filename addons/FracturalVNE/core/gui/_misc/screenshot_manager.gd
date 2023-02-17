extends Node
# A service that can take screenshots at runtime


# Since taking screenshots takes time, the process is asynchronous
# and finished_screenshot() get called when the service finishes taking
# a screenshot.
signal finished_screenshot(screenshot)

export var facade_viewport_texture_rect_path: NodePath
export var story_gui_configurer_path: NodePath
export var world_path: NodePath
export var screenshot_viewport_path: NodePath
export var screenshot_gui_holder_path: NodePath

# The latest screenshot taken
var screenshot
var is_taking_screenshot: bool = false

onready var facade_viewport_texture_rect = get_node(facade_viewport_texture_rect_path)
onready var story_gui_configurer = get_node(story_gui_configurer_path)
onready var world = get_node(world_path)
onready var screenshot_viewport = get_node(screenshot_viewport_path)
onready var screenshot_gui_holder = get_node(screenshot_gui_holder_path)


func _ready():
	pass


# Screenshots the entire screen
func screenshot(callback = null):
	if is_taking_screenshot:
		return
	
	is_taking_screenshot = true
	var image = get_viewport().get_texture().get_data()
	
	image.flip_y()
	
	var texture = ImageTexture.new()
	texture.create_from_image(image, Texture.FLAG_FILTER)
	
	screenshot = texture
	is_taking_screenshot = false
	_finished_screenshot(screenshot, callback)


# Screenshots all gameplay related nodes (excludes pause menu).

# HACK: Entire screenshot method is a disgusting mess of reparenting due to Godot's
# 		terrible support for viewports. (ie. viewports not receiving unhandled_input, 
#		etc)
func screenshot_gameplay(callback = null):
	if is_taking_screenshot:
		return
	
	is_taking_screenshot = true
	
	# Enable the screenshot viewport
	screenshot_viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	
	# Reparent the world as a child of the viewport
	var world_holder = world.get_parent()
	world_holder.remove_child(world)
	screenshot_viewport.add_child(world)
	
	# Reparent the gui as a child of the viewport's gui holder
	story_gui_configurer.story_gui_holder.remove_child(story_gui_configurer.story_gui)
	screenshot_gui_holder.add_child(story_gui_configurer.story_gui)
	
	# Create a screenshot of the entire view before performing the actual screenshot.
	# This preliminary screenshot will be pasted over the screen in another viewport
	# while the real screenshot is taken.
	var facade_image = get_viewport().get_texture().get_data()
	
	# Flip the Y axis since the viewport texture is actually flipped vertically..
	facade_image.flip_y()
	
	# Convert Image to ImageTexture.
	var facade_texture = ImageTexture.new()
	facade_texture.create_from_image(facade_image, Texture.FLAG_FILTER)
	
	facade_viewport_texture_rect.texture = facade_texture
	facade_viewport_texture_rect.visible = true
	
	yield(get_tree(), "idle_frame")

	var original_pause_menu_visibility
	if story_gui_configurer.story_gui.pause_menu != null:
		original_pause_menu_visibility = story_gui_configurer.story_gui.pause_menu.visible
		story_gui_configurer.story_gui.pause_menu.visible = false

	yield(get_tree(), "idle_frame")

	var viewport_texture_image = screenshot_viewport.get_texture().get_data()
	viewport_texture_image.flip_y()

	var viewport_texture = ImageTexture.new()
	viewport_texture.create_from_image(viewport_texture_image, Texture.FLAG_FILTER)

	if story_gui_configurer.story_gui.pause_menu != null:
		story_gui_configurer.story_gui.pause_menu.visible = original_pause_menu_visibility

	# Take down the temporary viewport texture
	facade_viewport_texture_rect.visible = false
	facade_viewport_texture_rect.texture = null
	
	# move the world outside of the viewport to it's original place
	screenshot_viewport.remove_child(world)
	world_holder.add_child(world)
	
	# Move the gui outside of the viewport gui holder to it's original place
	screenshot_gui_holder.remove_child(story_gui_configurer.story_gui)
	story_gui_configurer.story_gui_holder.add_child(story_gui_configurer.story_gui)
	
	# Disable the screenshot viewport
	screenshot_viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
	
	screenshot = viewport_texture
	is_taking_screenshot = false
	_finished_screenshot(screenshot, callback)


func _finished_screenshot(screenshot, callback):
	emit_signal("finished_screenshot", screenshot)
	if callback != null:
		callback.call_func(screenshot)
