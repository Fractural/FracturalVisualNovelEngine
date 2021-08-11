extends Node
# Saves and loads story save slots to and from save files.


# ----- Typeable ----- #
func get_types() -> Array:
	return ["StorySaveManager"]

# ----- Typeable ----- #


signal state_saved(save_state)

const MAX_SAVE_SLOTS = 6
const SAVE_FILES_DIRECTORY = "user://saves/"
const SaveState = preload("res://addons/FracturalVNE/core/io/save_state.gd")

var save_slots = []


func _ready() -> void:
	preload_save_slots()
	
	var dir = Directory.new()
	var err = dir.open("user://")
	
	assert(err == OK, "Error occured while opening file: " + str(err))
	
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")


func save_state(save_state, save_slot_id: int):
	save_slots[save_slot_id] = save_state
	var save_file = File.new()
	
	var err = save_file.open_compressed(SAVE_FILES_DIRECTORY + "save_slot_" + str(save_slot_id) + ".save", File.WRITE)
	
	assert(err == OK, "Error occured while opening file: " + str(err))
	
	save_file.store_string(JSON.print(save_state.serialize()))
	save_file.close()
	emit_signal("state_saved", save_state)


func get_save_slot(save_slot_id: int):
	return save_slots[save_slot_id]


func has_save_slot(save_slot_id: int):
	return save_slot_id >= 0 and save_slot_id < save_slots.size() and save_slots[save_slot_id] != null


func preload_save_slots():
	save_slots = []
	for i in range(MAX_SAVE_SLOTS):
		var save_file = File.new()
		var save_file_path = SAVE_FILES_DIRECTORY + "/save_slot_" + str(i) + ".save"
		
		if save_file.file_exists(save_file_path):
			var err = save_file.open_compressed(save_file_path, File.READ)
			assert(err == OK, "Could not load save slot #%s." % str(i))
			var parse_result = JSON.parse(save_file.get_as_text())
			assert(parse_result.error == OK, "Could not parse save file.")
			save_slots.append(SerializationUtils.deserialize(parse_result.result))
			save_file.close()
		else:
			save_slots.append(null)
