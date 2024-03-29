extends Reference


const Utils = preload("res://addons/FracturalVNE/core/story_script/story_script_utils.gd")
const Error = preload("res://addons/FracturalVNE/core/story_script/story_script_error.gd")
const FuncDef = preload("res://addons/FracturalVNE/core/story_script/story_script_function_definition.gd")
const Param = preload("res://addons/FracturalVNE/core/story_script/story_script_parameter.gd")
const Argument = preload("res://addons/FracturalVNE/core/story_script/story_script_argument.gd")
const Position = preload("res://addons/FracturalVNE/core/story_script/story_script_position.gd")

const Reader = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_reader.gd")
const TokensReader = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_tokens_reader.gd")

const NodeConstructConstants = preload("res://addons/FracturalVNE/core/story_script/node_construct_constants.gd")
const Lexer = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_lexer.gd")
const Parser = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_parser.gd")
const Compiler = preload("res://addons/FracturalVNE/core/story_script/compiling/story_script_compiler.gd")
