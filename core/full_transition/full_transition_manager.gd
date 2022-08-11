extends Node
# Makes full screen transitions that support loading
# in between transitions.


# ----- Typeable ----- #

func get_types() -> Array:
	return ["StoryScriptService", get_service_name()]

# ----- Typeable ----- #


# ----- StoryService ----- #

func configure_service(program_node):
	_cleanup()


func get_service_name():
	return "FullTransitionManager"

# ----- StoryService ----- #


signal transition_in_finished()
signal transition_out_finished()

export var new_texture_rect_path: NodePath
export var old_texture_rect_path: NodePath
export var replace_transitioner_path: NodePath
export var screenshot_manager_path: NodePath
export var story_director_path: NodePath

var is_transitioning: bool = false
var curr_transition
var duration
var is_skippable: bool

var _curr_transition_action

onready var new_texture_rect: TextureRect = get_node(new_texture_rect_path)
onready var old_texture_rect: TextureRect = get_node(old_texture_rect_path)
onready var replace_transitioner = get_node(replace_transitioner_path)
onready var screenshot_manager = get_node(screenshot_manager_path)
onready var story_director = get_node(story_director_path)


func _ready():
	replace_transitioner.init(story_director)
	replace_transitioner.connect("ready_for_loading", self, "_on_ready_for_loading")
	replace_transitioner.connect("transition_finished", self, "_on_transition_finished")


func start_transition(transition, is_skippable_: bool, duration_: int = 1):
	if is_transitioning:
		return
	
	duration = duration_
	curr_transition = transition
	is_skippable = is_skippable_
	is_transitioning = true
	
	new_texture_rect.visible = false
	old_texture_rect.visible = false
	# TODO DISCUSS: It seems like alot of VNs by default do not
	# 				transition the UI in these full transitions. Right now
	#				we transition everything since we are using
	#				a screenshot of the entire game (UI included).
	screenshot_manager.screenshot_gameplay(funcref(self, "_on_finished_screenshot_for_start_transition"))


func _on_finished_screenshot_for_start_transition(screenshot):
	old_texture_rect.texture = screenshot
	# "false" forces the transition to stop for loading instead
	# of immediately transitioning out after transitioning in.
	replace_transitioner.replace(curr_transition, duration, is_skippable, false)


func resume_transition():
	screenshot_manager.screenshot_gameplay(funcref(self, "_on_finished_screenshot_for_resume_transition"))


func _on_finished_screenshot_for_resume_transition(screenshot):
	new_texture_rect.texture = screenshot
	replace_transitioner.finished_loading()


func _on_ready_for_loading():
	emit_signal("transition_in_finished")


func _on_transition_finished(transition_type, skipped):
	_cleanup()
	emit_signal("transition_out_finished")


func _cleanup():
	new_texture_rect.visible = false
	old_texture_rect.visible = false
	is_transitioning = false
	curr_transition = null
