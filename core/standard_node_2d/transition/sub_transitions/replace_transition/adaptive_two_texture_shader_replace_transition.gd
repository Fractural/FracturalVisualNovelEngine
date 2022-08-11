extends "replace_transition.gd"
# Uses a shader fed with two textures to replace
# an old node with a new node.
#
# This only works with single nodes, therefore
# compound nodes will not be able to use this transition
# unless they render themselves to a texture via a viewport.


# -- Compatability -- #

# This only supports Actors with TextureHolders (like MultiVisuals).

# -- Compatability -- #



# ----- Typeable ----- #

func get_types() -> Array:
	var arr = .get_types()
	arr.append("AdaptiveTwoTextureShaderReplaceTransition")
	return arr

# ----- Typeable ----- #


const SSUtils = FracVNE.StoryScript.Utils
const FracUtils = FracVNE.Utils

export var node_2d_transition_texture_holder_path: NodePath
export var control_transition_texture_holder_path: NodePath
export var transition_curve: Curve

var transition_texture_holder
var time: float

onready var node_2d_transition_texture_holder = get_node(node_2d_transition_texture_holder_path)
onready var control_transition_texture_holder = get_node(control_transition_texture_holder_path)


func _ready() -> void:
	set_process(false)


func transition(new_node_: Node, old_node_: Node, duration_: float, is_skipping_loading_: bool = true):
	if not _setup_transition(new_node_, old_node_, duration_, is_skipping_loading_):
		return
	_start_loading()


func finished_loading():
	var new_texture: Texture
	var old_texture: Texture
	
	if FracUtils.is_type(new_node, "TextureHolder"):
		new_texture = new_node.get_holder_texture()
	else:
		return SSUtils.error("Expected new_node to be a TextureHolder.")

	if FracUtils.is_type(old_node, "TextureHolder"):
		old_texture = old_node.get_holder_texture()
	else:
		return SSUtils.error("Expected old_node to be a TextureHolder.")

	new_node.visible = false
	old_node.visible = false

	if FracUtils.is_type(new_node, "Control"):
		transition_texture_holder = control_transition_texture_holder
	else:
		transition_texture_holder = node_2d_transition_texture_holder

	transition_texture_holder.texture = new_texture
	transition_texture_holder.material.set_shader_param("old_texture", old_texture)

	time = 0
	set_process(true)


func _process(delta) -> void:
	if time < duration:
		time += delta
		transition_texture_holder.material.set_shader_param("progress", transition_curve.interpolate(time / duration))
	else:
		_on_transition_finished(false)


func _on_transition_finished(skipped: bool) -> void:
	set_process(false)
	._on_transition_finished(skipped)
