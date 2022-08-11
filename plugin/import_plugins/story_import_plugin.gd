extends EditorImportPlugin
# Imports a ".story" file.
# Doesn't actually save anything, but instead 
# lets the Godot editor see the file in the FileSystem.


func get_importer_name():
	return "FracVNE.story"


func get_visible_name():
	return "Story"


func get_recognized_extensions():
	return ["story"]


func get_save_extension():
	return "res"


func get_resource_type():
	return "Resource"


func get_preset_count():
	return 0


func get_preset_name(preset):
	return "Default"


func get_import_options(preset):
	return []


func get_option_visibility(option, options):
    return true


func import(source_file, save_path, options, r_platform_variants, r_gen_files):
    return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], Resource.new())
