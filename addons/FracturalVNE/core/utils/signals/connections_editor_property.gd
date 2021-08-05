extends EditorProperty


const SignalConnection = preload("signal_connection.gd")

var ERASE_ICON: Texture
var ASSIGN_ICON: Texture
var BOTTOM_MARGIN: int
var INDEX_LABEL_SIZE: int

var updating: bool = false
var spin = EditorSpinSlider
var connections_holder: VBoxContainer
var collapseable_bottom: Control
var collapse_button: Button
var collapsed: bool = false
var curr_assign_connection_index = -1

var node_path_editor_prop = null
var node_path_assigned_button = null

var icon_fetch_prop = null
var icon_fetch_assigned_button = null

var set_connection_icon_queue = []


func _ready() -> void:
	connections_holder = VBoxContainer.new()
	
	var spin_label = Label.new()
	spin_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spin_label.text = "Size:"
	
	spin = EditorSpinSlider.new()
	spin.set_min(0)
	spin.set_max(1000)
	spin.connect("value_changed", self, "_spin_changed")
	spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_focusable(spin)
	
	var spin_holder = HBoxContainer.new()
	spin_holder.add_child(spin_label)
	spin_holder.add_child(spin)
	
	var vbox = VBoxContainer.new()
	vbox.add_child(spin_holder)
	vbox.add_child(connections_holder)
	
	collapseable_bottom = MarginContainer.new()
	collapseable_bottom.add_constant_override("margin_bottom", BOTTOM_MARGIN)
	collapseable_bottom.add_child(vbox)
	
	collapse_button = Button.new()
	collapse_button.connect("pressed", self, "toggle_bottom_collapsed")
	
	add_child(collapse_button)
	add_child(collapseable_bottom)
	set_bottom_editor(collapseable_bottom)
	
	set_bottom_collapsed(false)


func _process(delta) -> void:
	if set_connection_icon_queue.size() > 0:
		var set_connection_icon_obj = set_connection_icon_queue.pop_front()
		set_connection_icon(set_connection_icon_obj.connection, set_connection_icon_obj.index)


func show_node_path_selector(index):
	curr_assign_connection_index = index
	var assign_node_path_button = get_node("../EditorPropertyNodePath/HBoxContainer/Button")
	if assign_node_path_button != null:
		assign_node_path_button.emit_signal("pressed")


func update_property():
	if node_path_editor_prop == null:
		return
	
	var new_connections_array = get_edited_object()[get_edited_property()]
	
	if new_connections_array == null:
		emit_changed(get_edited_property(), [])
		return
	
	updating = true
	spin.set_value(new_connections_array.size())
	var connection_uis = connections_holder.get_children()
	if new_connections_array.size() >= connection_uis.size():
		for i in new_connections_array.size():
			if i < connection_uis.size():
				set_connection(new_connections_array[i], i)
			else:
				add_connection(new_connections_array[i], i)
	else:
		for i in range(connection_uis.size() - 1, new_connections_array.size() - 1, -1):
			connection_uis[i].queue_free()
			connection_uis.remove(i)
	updating = false


func add_connection(connection, index: int):
	var connection_ui = HBoxContainer.new()
	connection_ui.name = "Connection%s" % str(index)
	var index_label = Label.new()
	index_label.name = "IndexLabel"
	index_label.text = str(index)
	index_label.rect_min_size.x = INDEX_LABEL_SIZE
	index_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	connection_ui.add_child(index_label)
	
	var assign_button = Button.new()
	assign_button.name = "AssignButton"
	assign_button.clip_text = true
	assign_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	assign_button.size_flags_stretch_ratio = 5
	add_focusable(assign_button)
	assign_button.connect("pressed", self, "show_node_path_selector", [index])
	connection_ui.add_child(assign_button)
	var function_line_edit = LineEdit.new()
	function_line_edit.name = "FunctionLineEdit"
	function_line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	function_line_edit.size_flags_stretch_ratio = 5
	function_line_edit.connect("text_changed", self, "_on_connection_function_changed", [index])
	add_focusable(function_line_edit)
	connection_ui.add_child(function_line_edit)
	
	# Inspector uses the default minimum width as it's benchmark.
	# If anything has a minimum width beyond this the inspector will 
	# automatically resize -- even if the inspector currently has adequate
	# room and does not need to resize.
	var erase_button = Button.new()
	erase_button.icon = ERASE_ICON
	add_focusable(erase_button)
	connection_ui.add_child(erase_button)
	erase_button.rect_min_size.x = 0
	erase_button.connect("pressed", self, "_on_erase_button_pressed", [index])
	
	connection_ui.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	connections_holder.add_child(connection_ui)
	
	set_connection(connection, connections_holder.get_child_count() - 1)


func set_connection(connection, index):
	var connection_ui = connections_holder.get_child(index)
	var assign_button = connection_ui.get_node("AssignButton")
	var function_line_edit = connection_ui.get_node("FunctionLineEdit")
	
	if not connection.listener_path.is_empty():
		assign_button.text = connection.listener_path.get_name(connection.listener_path.get_name_count() - 1)
	else:
		assign_button.text = "Assign..."
	
	if function_line_edit.text != connection.func_name:
		function_line_edit.text = connection.func_name
	
	for i in range(set_connection_icon_queue.size() - 1, 0, -1):
		if set_connection_icon_queue[i].index == index:
			return
	
	set_connection_icon_queue.append({
		"connection": connection,
		"index": index
	})


func set_connection_icon(connection, index):
	var connection_ui = connections_holder.get_child(index)
	var assign_button = connection_ui.get_node("AssignButton")
	
	if not connection.listener_path.is_empty():
		icon_fetch_prop.emit_changed(icon_fetch_prop.get_edited_property(), connection.listener_path)
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		assign_button.icon = icon_fetch_assigned_button.icon
	else:
		assign_button.icon = null


func set_bottom_collapsed(collapsed_):
	collapsed = collapsed_
	collapseable_bottom.visible = not collapsed
	if collapsed:
		collapse_button.text = "Show"
	else:
		collapse_button.text = "Hide"


func toggle_bottom_collapsed():
	grab_click_focus()
	set_bottom_collapsed(not collapsed)


func clear_connections():
	for connection in connections_holder.get_children():
		connection.set_connection_icon_queue_free()


func _on_node_selected(property, selected_node_path, field, changing):
	if updating:
		return
	
	_on_connection_listener_path_changed(selected_node_path, curr_assign_connection_index)


func _hijack_dummy_node_path_editor_prop():
	#_dump_tree(get_parent(), "", true)
	
	node_path_editor_prop = get_node("../EditorPropertyNodePath")
	node_path_editor_prop.connect("property_changed", self, "_on_node_selected")
	
	node_path_assigned_button = node_path_editor_prop.get_node("HBoxContainer/Button")
	node_path_assigned_button.emit_signal("pressed")

	icon_fetch_prop =  get_node("../EditorPropertyNodePath2")
	icon_fetch_assigned_button = icon_fetch_prop.get_node("HBoxContainer/Button")
#	var node_dialog = get_node("../EditorPropertyNodePath/SceneTreeDialog")
#	node_dialog.connect("popup_hide", self, "_on_node_selection_closed")

	# If the hide button is ever needed, you can find it here.
	var ok_button = node_path_editor_prop.get_node("SceneTreeDialog/HBoxContainer/Button")
	ok_button.emit_signal("pressed")
#	var cancel_button = get_node("../EditorPropertyNodePath/SceneTreeDialog/HBoxContainer/Button2")
#	cancel_button.connect("pressed", self, "_on_node_selection_closed")
	
	#hide_button.emit_signal("pressed")
		
	node_path_editor_prop.visible = false
	icon_fetch_prop.visible = false
	
	# Hijacking happens after the data is first set, therefore we must
	# set the icons (Since they could not fetched when the data was first set).
	update_property()


func _spin_changed(value):
	if (updating):
		return
	
	var resized_array = get_edited_object()[get_edited_property()]
	resized_array.resize(value)
	
	for i in resized_array.size():
		if resized_array[i] == null:
			resized_array[i] = SignalConnection.new(NodePath(), "function()")
	
	emit_changed(get_edited_property(), resized_array)


func _on_connection_listener_path_changed(new_listener_path, index):
	if updating:
		return
	
	var edited_array = get_edited_object()[get_edited_property()]
	edited_array[index].listener_path = new_listener_path
	emit_changed(get_edited_property(), edited_array)


func _on_connection_function_changed(new_function_name, index):
	if (updating):
		return
	
	var edited_array = get_edited_object()[get_edited_property()]
	edited_array[index].func_name = new_function_name
	emit_changed(get_edited_property(), edited_array)


func _on_erase_button_pressed(index):
	if (updating):
		return
	
	var edited_array = get_edited_object()[get_edited_property()]
	edited_array[index].listener_path = NodePath()
	emit_changed(get_edited_property(), edited_array)


# ----- Asset Scaling ----- #

func _setup_editor_assets(assets_registry):
	ERASE_ICON = assets_registry.load_asset("assets/icons/eraser.svg")
	INDEX_LABEL_SIZE = assets_registry.get_editor_scale() * 25
	BOTTOM_MARGIN = assets_registry.get_editor_scale() * 5

# ----- Asset Scaling ----- #


# ----- Scene Walking/Debug ----- #

func _dump_tree(n: Node, ind: String="", allow: bool = false):
	print("\n\n\n\n\n\n\n\n\n")
	__dump_tree(n, ind, allow)


func __dump_tree(n: Node, ind: String="", allow: bool = false) -> void:
	if allow or n.get_class() == "EditorPropertyNodePath":
		if not allow:
			allow = true
		print("Path To Assign Button: \"%s\"" % get_path_to(n))
		print(ind + str(n.get_class()))
	for chld in n.get_children():
		__dump_tree(chld, ind + "    ", allow)

# ----- Scene Walking/Debug ----- #
