extends RichTextLabel

# The default time to wait before animating the next character
var default_char_delay: float

# Array of `CharactersDelay` that defines wait times for custom sets of characters. If a character is not included in any of the `CharactersDelays`, then it will wait a duration of `default_char_delay`.
var custom_char_delays: Array = []
var is_revealing: bool

var _animate_text_timer: float = 0

func init(default_char_delay_: float, custom_char_delays_: Array = []):
	default_char_delay = default_char_delay_
	custom_char_delays = custom_char_delays_

func _ready():
	# Keep process off until need to animate text
	set_process(false)

# We are using process to handle animating text every few seconds because as of Godot 3.2, 
# there is no way to inturrupt coroutines, meaning you cannot use timers to loops things over time

func _process(delta):
	_animate_text_tick(delta)

func start_reveal():
	if is_revealing:
		stop_reveal()
	
	self.visible_characters = 0
	_animate_text_timer = 0
	is_revealing = true
	set_process(true)

func stop_reveal():
	self.visible_characters = -1
	is_revealing = false
	set_process(false)

func _animate_text_tick(delta):
	_animate_text_timer -= delta
	if _animate_text_timer <= 0:
		self.visible_characters += 1
		if self.visible_characters < self.text.length():
			_animate_text_timer = _get_char_delay(self.text[self.visible_characters])

			# If the current char's delay is 0, immediately animate the next char
			# We animate next char with a delta of 0 since we already did "_animate_text_timer -= delta" this tick
			if _animate_text_timer == 0:
				_animate_text_tick(0)
		else:
			stop_reveal()

func _get_char_delay(ch: String) -> float:
	for character_delay in custom_char_delays:
		if ch in character_delay.characters:
			return character_delay.delay
	return default_char_delay
