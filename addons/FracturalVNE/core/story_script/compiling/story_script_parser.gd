class_name StoryScriptParser
extends Reference

const EOF = "EOF"

var reader: StoryScriptTokensReader

var constructs_dict = StoryScriptConstants.new().CONSTRUCTS_DICT

func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
	reader = reader_
	return expect("program")

func expect(construct_names):
	var errors = []
	if typeof(construct_names) == TYPE_STRING:
		construct_names = [construct_names]
	for name in construct_names:
		if constructs_dict.has(name):
			for construct in constructs_dict[name]:
				errors.append(construct.parse(self))
				if is_success(errors.back()):
					return errors.back()
				elif errors.back().confidence == 1:
					# Bail statement for when you are absolutely sure this 
					# the parsed statement is an error
					return errors.back()
		else:
			return error('Unknown construct of type: "%s"' % [name], 1)
	
	if errors.size() == 0:
		return error("Unknown token.")
	
	var closest_error = errors.front()
	for error in errors:
		if error.confidence > closest_error.confidence:
			closest_error = error
	
	if closest_error.confidence == 0:
		closest_error.message = "Unknown token."
		return closest_error
	
	return closest_error

func expect_token(token_type: String, token_symbol = null):
	if token_type == reader.peek().type:
		if token_symbol != null:
			if token_symbol == reader.peek().symbol:
				return reader.consume()
			else:
				return error("Expected %s token with symbol of %s" % [token_type, str(token_symbol)])
		else:
			return reader.consume()
	if token_symbol == null:
		return error("Expected token with type %s." % token_type)
	else:
		return error("Expected %s token with symbol of %s" % [token_type, str(token_symbol)])

func load_reader_state(new_state):
	reader = new_state

func save_reader_state():
	return reader.clone()

func is_success(result):
	return result != null and not result is StoryScriptError

func peek(steps_ahead: int = 1):
	return reader.peek(steps_ahead)

func is_EOF():
	return reader.is_EOF()

func consume(steps_ahead: int = 1):
	return reader.consume(steps_ahead)

func unconsume(steps_behind: int = 1):
	return reader.unconsume(steps_behind)

func error(error, confidence: float = 0, checkpoint = null):
	var position = reader.peek().position
	
	if checkpoint != null:
		load_reader_state(checkpoint)
	
	if typeof(error) == TYPE_STRING:
		return StoryScriptError.new(error, position, confidence)
	elif error is StoryScriptError:
		error.confidence = confidence
		return error
	else:
		assert(false, "Unknown use of error().")
