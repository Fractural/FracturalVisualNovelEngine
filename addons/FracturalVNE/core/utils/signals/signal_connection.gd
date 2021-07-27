extends Resource


export var listener_path: NodePath
export var func_name: String


func _init(listener_path_: NodePath = NodePath(), func_name_: String = ""):
	listener_path = listener_path_
	func_name = func_name_
