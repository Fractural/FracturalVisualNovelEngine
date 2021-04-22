extends Node
class_name StoryProcessor

# Instructions
# - SceneTransition
# - Definitions
#  - [load (filepath)]
#    - Tells compiler to check for resource files (images, music, etc) in this location
#  - [define (character) = Character(name, color)]
#  - [define (sprite) = Sprite(filePath)]
# - Speech
#  - [ "" ]
#    - shows text without a name
#  - [ "name" "" ]
#    - shows text with a name
#  - [(characterName) "" ]
#    - shows text with name (this is speaking basically)
# - Move
#  - [move (arg) to (position)]
#   - Moves a sprite/character to a position can be left, right, center, or a specific x-position
# - Transitions
#  - [show (sprite) (image name) with (transition)]
#    - Shows character
#    - Shows a new scene
# - Animations
#  - [animate (sprite) with (animation)]
#    - Animates a sprite (character or regular sprite) with animation
# - Pause
#  - [pause (time)]
#   - Pause for a certain amount of time
# - Music
#  - [play music (musicPath)]
#    - Playing new 
#  - [stop music]
# - Sound
#  - [play sound (soundPath)]
# LATER:
# - Decisions
#  - [menu:]
#   - Brings up list of options. Options are separated by new lines and are each wrapped in a pair of "".
#  - [define (flag) = (defaultValue)]
# - Conditions
#  - [if (flag)] 
# - Labels (To support jumping)
#  - [label (labelName): ]
#  - [label start:]
#   - Where the program starts
#  - [jump (labelName)]

# StoryProcessor should compile all instructions into an array of instructions


const StoryInstruction = preload("storyinstruction.gd")

func process_story(story: String) -> Array:
    
    return []