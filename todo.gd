# TODO NOW: 
#	[X]	Add a fade to black scene transition
#	[X]	Add a crossfade transition
#
#	[X]	Refactor animate, show, and hide statements to all use
#		a dedicated object for each animation similar to how
#		scene_transition works for scene_manager.
#
#		[X]	Show and hide could use a visual_transition.gd class
#		[X]	Animate could use an animate.gd class
#
#	[ ]	Add global constants such as:
#
#		[ ]	PosLeft and PosRight to represent Vector2 on right and left side of
#			the screen. These constants could then be used in move statements.
#
#	[X] Use FracVNE.Utils.is_type(object, type) whenever you do a type check
#
#	[X] When saving, make StoryDirector skip all current actions before saving.
#
#	[X] Pause the world when the pause menu is up
#
#	[ ] Add custom methods to create animations and scenes to make them look cleaner.
#		(Maybe add Animation(), Scene(), and Curve() functions similar to how visuals 
#		are loaded with Visual() and DynamicVisual()?).
#	[X] Make the objects returned by Visual to just hold data about a visual. This then allows developers to choose when they want to load in visuals and when to cache visuals instead of forcing users to always cache visuals (by making the object returned by Visual() the ACTUAL visual node).
#	[ ] Write a remove statement that can remove Visuals
#		Example syntax:
#			define bob = Visual(...)
#			show bob
#			remove bob 			# Deletes the VisualController
#	[ ] Follow the structure of Visuals and VisualControllers
#		and design Scenes to operate in a similar manner.
#		The remove statement should work with scene as well.
#	[ ]	Add type checking for StoryScript binded functions 
#		into the Block's function handling part. We would also
#		have to add an parameter in StoryScript.Param._init() to 
#		accept a type as a string. If this parameter is blank
#		then the StoryScript.Param will accept any type.  
#	[X] Refactor Visual and Scene transitions to use the same universal transition class.
#	[ ] FIX BUGGY AF STORY DIRECTOR
#		[ ] Find cause of parenting issues with transitions (Likely due to order of execution?)
#		[ ] Find the cause of auto step skipping the first pause statement in visuals_testing.story_script
#	[ ] Refactor AST constructs to return arrays of nodes. This allows for statements to return more than
#		one node to compose new behaviour. Or maybe consider making a special block statement that wraps
#		around groups of statements to allow for multi-statement returning in the current impelemtnation of
#		AST construction. 
#	[ ] Refactor transitions to take in parameters
#		[ ] Maybe add support for loading animations directly as transitions?
#			Seems too niche though...
# 	[X] Implement multiple printers and saving (Make each printer saves it's own dialog) 
#		[ ] Make it optional to add such dialog to the dialog history)
#	[ ] Some transitions like crossfade will not support prefab transitions by default for performance reason