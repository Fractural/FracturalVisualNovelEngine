# Only works on linux
# Requires zip utility (apt install zip)

MONO_DIR = _modules/mono
PLUGIN_DIR = addons/FracturalVNE

.PHONY: releases gdscript-release mono-release release-folder

releases: mono-release gdscript-release
	echo "All releases have been built."

gdscript-release: release-folder
	zip -r "releases/FracturalVNE.zip" $(PLUGIN_DIR) -x $(PLUGIN_DIR)/$(MONO_DIR)/*
	echo "GDScript release building done."

mono-release: release-folder
	zip -r "releases/MonoFracturalVNE.zip" $(PLUGIN_DIR)
	echo "Mono release building done."

release-folder:
	mkdir -p "releases"