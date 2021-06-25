extends Node

export var text_edit_path: NodePath
export var compiler_path: NodePath

onready var text_edit = get_node(text_edit_path)
onready var compiler: StoryScriptCompiler = get_node(compiler_path)

func load__story_script__print_tokens(script) -> void:
	# parameters([["script", "correct_tokens"], ["test (): asdf sdfd 0.23343 44"]])
	var lexed_tokens = compiler.lexer.generate_tokens(StoryScriptReader.new(script))

	# # asserts.is_equal(lexed_tokens.length(), p.correct_tokens.length(), "Lexed tokens is same size as correct tokens")

	# # for i in range(p.correct_tokens.length()):
	# # 	asserts.is_true(lexed_tokens[i].type == p.correct_tokens[i].type, "Lexed token type %s equals %s" % [lexed_tokens[i].type, p.correct_tokens[i].type])
	# # 	asserts.is_true(lexed_tokens[i].symbol == p.correct_tokens[i].symbol, "Lexed token symbol %s equals %s" % [str(lexed_tokens[i].symbol), str(p.correct_tokens[i].symbol)])
	
	print("Tokens:")
	for token in lexed_tokens:
		print(token)

	print("\n")
