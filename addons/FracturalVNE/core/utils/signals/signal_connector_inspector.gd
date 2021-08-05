extends EditorInspectorPlugin
# Handles inspector for the SignalConnector node


const InspUtils = FracVNE.InspectorUtils
const ConnectionsEditorProperty = preload("connections_editor_property.gd")

var assets_registry
var curr_signal_editor


func can_handle(object):
    return object is SignalConnector
	

func parse_begin(object):
	curr_signal_editor = null


func parse_property(object, type, path, hint, hint_text, usage):
	if path == "_connections_collapsed":
		return true
	elif path == "connections":
		curr_signal_editor = ConnectionsEditorProperty.new()
		curr_signal_editor._setup_editor_assets(assets_registry)
		add_property_editor("connections", curr_signal_editor)
		return true
	else:
		return false

func parse_end():
	curr_signal_editor._hijack_dummy_node_path_editor_prop()


func _setup_editor_assets(assets_registry_):
	assets_registry = assets_registry_
