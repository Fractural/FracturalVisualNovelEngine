extends Viewport

enum STRETCH_MODE { DISABLED, TWO_D, VIEWPORT }
enum STRETCH_ASPECT { IGNORE, KEEP, KEEP_WIDTH, KEEP_HEIGHT, EXPAND }

export(STRETCH_MODE) var stretch_mode = STRETCH_MODE.DISABLED
export(STRETCH_ASPECT) var stretch_aspect = STRETCH_MODE.DISABLED
export var stretch_scale: float = 1
export var override_project_settings: bool = false
export var stretch_min: Vector2 
export var modify_visual_server: bool = false

func _ready() -> void:
	print("_ready")
	get_tree().root.connect("size_changed", self, "update_viewport")
	if not override_project_settings:
		stretch_min = \
			Vector2(ProjectSettings.get_setting("display/window/size/width"), \
			ProjectSettings.get_setting("display/window/size/height"))
		stretch_scale = ProjectSettings.get_setting("display/window/stretch/shrink")
		match ProjectSettings.get_setting("display/window/stretch/mode"):
			"2d":
				stretch_mode = STRETCH_MODE.TWO_D
			"viewport":
				stretch_mode = STRETCH_MODE.VIEWPORT
			_:
				stretch_mode = STRETCH_MODE.DISABLED
		match ProjectSettings.get_setting("display/window/stretch/aspect"):
			"keep":
				stretch_aspect = STRETCH_ASPECT.KEEP
			"keep_width":
				stretch_aspect = STRETCH_ASPECT.KEEP_WIDTH
			"keep_height":
				stretch_aspect = STRETCH_ASPECT.KEEP_HEIGHT
			"expand":
				stretch_aspect = STRETCH_ASPECT.EXPAND
			_:
				stretch_aspect = STRETCH_ASPECT.IGNORE
	update_viewport()

func update_canvas_items():
	_update_canvas_items(self)

func _update_canvas_items(node: Node):
	if node != self:
		if node is Viewport:
			return
		
		if node is CanvasItem:
			var canvas_item = node as CanvasItem
			canvas_item.update()
	
	for child in node.get_children():
		_update_canvas_items(child)

func update_viewport():
	if stretch_mode == STRETCH_MODE.DISABLED:
		var last_screen_size = OS.window_size
		set_size(last_screen_size.floor())
		set_attach_to_screen_rect(Rect2(Vector2(), last_screen_size))
		set_size_override_stretch(true)
		set_size_override(true, (last_screen_size / stretch_scale).floor())
		update_canvas_items()
		return

	var video_mode = OS.window_size
	var desired_res: Vector2 = stretch_min

	var viewport_size: Vector2
	var screen_size: Vector2

	var viewport_aspect: float = desired_res.aspect()
	var video_mode_aspect: float = video_mode.aspect()

	if stretch_aspect == STRETCH_ASPECT.IGNORE or is_equal_approx(viewport_aspect, video_mode_aspect):
		viewport_size = desired_res
		screen_size = video_mode
	elif viewport_aspect < video_mode_aspect:
		if stretch_aspect == STRETCH_ASPECT.KEEP_HEIGHT or stretch_aspect == STRETCH_ASPECT.EXPAND:
			# will stretch horizontally
			viewport_size.x = desired_res.y * video_mode_aspect
			viewport_size.y = desired_res.y
			screen_size = video_mode
		else:
			# will need black bars
			viewport_size = desired_res
			screen_size.x = video_mode.y * viewport_aspect
			screen_size.y = video_mode.y
	else:
		# screen ratio is smaller horizontally
		if stretch_aspect == STRETCH_ASPECT.KEEP_WIDTH or stretch_aspect == STRETCH_ASPECT.EXPAND:
			# will stretch horizontally
			viewport_size.x = desired_res.x
			viewport_size.y = desired_res.x / video_mode_aspect
			screen_size = video_mode
		else:
			# will need black bars
			viewport_size = desired_res
			screen_size.x = video_mode.x
			screen_size.y = video_mode.x / viewport_aspect

	screen_size = screen_size.floor()
	viewport_size = viewport_size.floor()

	var margin: Vector2
	var offset: Vector2
	# black bars and margin
	if stretch_aspect != STRETCH_ASPECT.EXPAND and screen_size.x < video_mode.x:
		margin.x = round((video_mode.x - screen_size.x) / 2.0)
		if modify_visual_server:
			VisualServer.black_bars_set_margins(margin.x, 0, margin.x, 0)
		offset.x = round(margin.x * viewport_size.y / screen_size.y)
	elif stretch_aspect != STRETCH_ASPECT.EXPAND and screen_size.y < video_mode.y:
		margin.y = round((video_mode.y - screen_size.y) / 2.0)
		if modify_visual_server:
			VisualServer.black_bars_set_margins(0, margin.y, 0, margin.y)
		offset.y = round(margin.y * viewport_size.x / screen_size.x)
	else:
		VisualServer.black_bars_set_margins(0, 0, 0, 0)

	match stretch_mode:
		# STRETCH_MODE.DISABLED:
			# Already handled above
		STRETCH_MODE.TWO_D:
			# _update_font_oversampling((screen_size.x / viewport_size.x) * stretch_scale) //screen / viewport ratio drives oversampling
			set_size(screen_size.floor())
			set_attach_to_screen_rect(Rect2(margin, screen_size))
			set_size_override_stretch(true)
			set_size_override(true, (viewport_size / stretch_scale).floor())
			update_canvas_items() # force them to update just in case
		STRETCH_MODE.VIEWPORT:
			# _update_font_oversampling(1.0)
			set_size((viewport_size / stretch_scale).floor())
			set_attach_to_screen_rect(Rect2(margin, screen_size))
			set_size_override_stretch(false)
			set_size_override(false, Vector2())
			update_canvas_items() # force them to update just in case
