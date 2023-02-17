extends Viewport

enum STRETCH_MODE { DISABLED, TWO_D, VIEWPORT }
enum STRETCH_ASPECT { IGNORE, KEEP_HEIGHT, EXPAND }

export(STRETCH_MODE) var strecth_mode = STRETCH_MODE.DISABLED
export(STRETCH_ASPECT) var strecth_aspect = STRETCH_MODE.DISABLED

func _ready() -> void:
	get_tree().root.connect("size_changed", self, "update_viewport")
	update_viewport()

func update_viewport():
	get_tree().set_screen_stretch(SceneTree.stretch)
	if stretch_mode == STRETCH_MODE.DISABLED:
		set_size(OS.window_size.floor())
		set_attach_to_screen_rect(Rect2(Point2(), last_screen_size))
		set_size_override_stretch(true)
		set_size_override(true, (last_screen_size / stretch_scale).floor())
		update_canvas_items()
		return

	Size2 video_mode = OS::get_singleton()->get_window_size();
	Size2 desired_res = stretch_min;

	Size2 viewport_size;
	Size2 screen_size;

	float viewport_aspect = desired_res.aspect();
	float video_mode_aspect = video_mode.aspect();

	if (stretch_aspect == STRETCH_ASPECT_IGNORE || Math::is_equal_approx(viewport_aspect, video_mode_aspect)) {
		//same aspect or ignore aspect
		viewport_size = desired_res;
		screen_size = video_mode;
	} else if (viewport_aspect < video_mode_aspect) {
		// screen ratio is smaller vertically

		if (stretch_aspect == STRETCH_ASPECT_KEEP_HEIGHT || stretch_aspect == STRETCH_ASPECT_EXPAND) {
			//will stretch horizontally
			viewport_size.x = desired_res.y * video_mode_aspect;
			viewport_size.y = desired_res.y;
			screen_size = video_mode;

		} else {
			//will need black bars
			viewport_size = desired_res;
			screen_size.x = video_mode.y * viewport_aspect;
			screen_size.y = video_mode.y;
		}
	} else {
		//screen ratio is smaller horizontally
		if (stretch_aspect == STRETCH_ASPECT_KEEP_WIDTH || stretch_aspect == STRETCH_ASPECT_EXPAND) {
			//will stretch horizontally
			viewport_size.x = desired_res.x;
			viewport_size.y = desired_res.x / video_mode_aspect;
			screen_size = video_mode;

		} else {
			//will need black bars
			viewport_size = desired_res;
			screen_size.x = video_mode.x;
			screen_size.y = video_mode.x / viewport_aspect;
		}
	}

	screen_size = screen_size.floor();
	viewport_size = viewport_size.floor();

	Size2 margin;
	Size2 offset;
	//black bars and margin
	if (stretch_aspect != STRETCH_ASPECT_EXPAND && screen_size.x < video_mode.x) {
		margin.x = Math::round((video_mode.x - screen_size.x) / 2.0);
		VisualServer::get_singleton()->black_bars_set_margins(margin.x, 0, margin.x, 0);
		offset.x = Math::round(margin.x * viewport_size.y / screen_size.y);
	} else if (stretch_aspect != STRETCH_ASPECT_EXPAND && screen_size.y < video_mode.y) {
		margin.y = Math::round((video_mode.y - screen_size.y) / 2.0);
		VisualServer::get_singleton()->black_bars_set_margins(0, margin.y, 0, margin.y);
		offset.y = Math::round(margin.y * viewport_size.x / screen_size.x);
	} else {
		VisualServer::get_singleton()->black_bars_set_margins(0, 0, 0, 0);
	}

	switch (stretch_mode) {
		case STRETCH_MODE_DISABLED: {
			// Already handled above
		} break;
		case STRETCH_MODE_2D: {
			_update_font_oversampling((screen_size.x / viewport_size.x) * stretch_scale); //screen / viewport ratio drives oversampling
			root->set_size(screen_size.floor());
			root->set_attach_to_screen_rect(Rect2(margin, screen_size));
			root->set_size_override_stretch(true);
			root->set_size_override(true, (viewport_size / stretch_scale).floor());
			root->update_canvas_items(); //force them to update just in case

		} break;
		case STRETCH_MODE_VIEWPORT: {
			_update_font_oversampling(1.0);
			root->set_size((viewport_size / stretch_scale).floor());
			root->set_attach_to_screen_rect(Rect2(margin, screen_size));
			root->set_size_override_stretch(false);
			root->set_size_override(false, Size2());
			root->update_canvas_items(); //force them to update just in case

		} break;
	}
