# TODO NOW: 
#	[X] Add "sound" statement that uses AudioManager to play a sound on a channel
#	[ ] Perform integration testing with "sound" statement.
#		[ ] Fix null reference exception for reparenting (Occurs in curve transition when reloading a save)
#	[X] Make lexer ignoring blank lines
#	[X] Make persisten editor data save to a file
#	[X] Fix propagate_call not returning error.


# TODO NEXT:
#	[ ] Write a remove statement that can remove Visuals
#		Example syntax:
#			define bob = Visual(...)
#			show bob
#			remove bob 			# Deletes the VisualController


# TODO QUEUE:
#	[ ]	Add type checking for StoryScript binded functions 
#		into the Block's function handling part. We would also
#		have to add an parameter in StoryScript.Param._init() to 
#		accept a type as a string. If this parameter is blank
#		then the StoryScript.Param will accept any type. 
#	[ ] Refactor transitions to take in parameters
#		[ ] Maybe add support for loading animations directly as transitions?
#			Seems too niche though...
#	[ ] Make it optional to add dialog from a printer to the dialog history)
# 	[ ] Add a loading functionality that loads an entire story script into the current story script.
#		This should happen on init time, and will likely require a reparenting AST nodes since
#		by default all StoryScripts are serialized with a ProgramNode.
#		[ ] Add lazy loading that only loads the entire story when the game reaches the load statement.
#			Maybe we would have to keep track of the lazy loads in an array in the serialized state and then
#			loaded the current loaded lazy loads whenever the state is deserialized. This array will basically
#			keep track of all loaded storyscripts and also the order they loaded in.
#		[ ]	Use this to add global constants by adding "define" statements in a "default_constants.storyscript"
#			and then loading "default_constants.storyscript". This lets users decide if they want to load in
#			things or not.
#			[ ]	PosLeft and PosRight to represent Vector2 on right and left side of
#				the screen. These constants could then be used in move statements.
#	[ ] Refactor all services to have a get_types() method.