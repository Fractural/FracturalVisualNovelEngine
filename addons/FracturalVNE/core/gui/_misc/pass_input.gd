extends ViewportContainer

export var viewport_path: NodePath

onready var viewport = get_node(viewport_path)

func _input( event ):
	if event is InputEventMouse:
		var mouseEvent = event.duplicate()
		mouseEvent.position = get_global_transform().xform_inv(event.global_position)
		viewport.unhandled_input(mouseEvent)
	else:
		viewport.unhandled_input(event)
