class_name StoryScriptParser
extends Reference

const EOF = "EOF"

var reader: StoryScriptTokensReader

var constructs = StoryScriptConstants.new().CONSTRUCTS

func generate_abstract_syntax_tree(reader_: StoryScriptTokensReader):
	reader = reader_

func expect(construct_name: String):
	for construct in constructs:
		if construct.get_parse_types().has(construct_name):
			return construct.parse(self)
	return error("Unexpected token.")

func expect_token(token_type: String, token_symbol = null):
	if token_type == reader.peek().type:
		if token_symbol != null:
			if token_symbol == reader.peek().symbol:
				return reader.consume()
			else:
				return error("Expected %s token with symbol of %s" % [token_type, str(token_symbol)])
		else:
			return reader.consume()
	return error("Expected token with type %s." % token_type)

func is_success(result):
	return result != null and not result is StoryScriptError

func peek(steps_ahead: int = 1):
	return reader.peek(steps_ahead)

func consume(steps_ahead: int = 1):
	return reader.consume(steps_ahead)

func unconsume(steps_behind: int = 1):
	return reader.unconsume(steps_behind)

func error(error, confidence: int = 0, checkpoint = null):
	if checkpoint != null:
		reader = checkpoint
	
	if typeof(error) == TYPE_STRING:
		return StoryScriptError.new(error, reader.peek().position, confidence)
	elif error is StoryScriptError:
		error.confidence = confidence
		return error
	else:
		assert(false, "Unknown use of error().")
