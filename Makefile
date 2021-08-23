# Only works on linux
# Requires zip utility (apt install zip)

MONO_DIR = _modules/mono
PLUGIN_DIR = addons/FracturalVNE
RELEASES = releases
CURR_DIR = $(shell pwd)

.PHONY: releases gdscript-release mono-release release-folder goto-plugin-dir

all: clean mono-release gdscript-release
	echo "All releases have been built."

gdscript-release: release-folder goto-plugin-dir
# Note that we use "/*" instead of just /* since
# the '*' will be interpreted as a multiplication
# operator otherwise. In order to keep the '*' as
# a wildcard, we have to put it inside a string.
	@echo $(CURR_DIR)/$(PLUGIN_DIR)/$(MONO_DIR)
	@cd $(CURR_DIR)/$(PLUGIN_DIR); \
		zip -q -r $(CURR_DIR)/$(RELEASES)"/FracturalVNE.zip" * -x $(MONO_DIR)"/*"
	@echo "GDScript release building done."

mono-release: release-folder goto-plugin-dir
	@cd $(CURR_DIR)/$(PLUGIN_DIR); \
		zip -q -r $(CURR_DIR)/$(RELEASES)/"MonoFracturalVNE.zip" *
	@echo "Mono release building done."

release-folder:
	mkdir -p $(RELEASES)

clean:
	cd $(CURR_DIR)/$(RELEASES); \
		rm *
	