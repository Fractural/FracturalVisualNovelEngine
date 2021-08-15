extends WAT.Test
# Tests ChoiceStatement


const FracUtils = FracVNE.Utils
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const ChoiceStatementBuilder = preload("res://tests/core/story_script/ast_nodes/statements/choice_statement/choice_statement.builder.gd")
const ChoiceManagerBuilder = preload("res://tests/core/story/choice/choice_manager.builder.gd")
const ChoiceOptionBuilder = preload("res://tests/core/story_script/ast_nodes/statements/choice_statement/choice_option.builder.gd")
const ProgramNodeBuilder = preload("res://tests/core/story_script/ast_nodes/misc/program_node/program_node.builder.gd")


# TODO: Finish tests for choice statement following TDD.
func title():
	return "ChoiceStatement"


func test_execute():
	describe("When calling execute() on ChoiceStatement")
	asserts.is_true(true, "TEMP TODO: Finish tests for choice.")	
#	# ----- Setup ----- #
#
#	var mock_story_director = direct.script_blank(StoryDirector)
#
#	var choice_options = [
#			ChoiceOptionBuilder.new().default(direct) \
#				.inject_choice_text("Choice 1") \
#				.build(),
#			ChoiceOptionBuilder.new().default(direct) \
#				.inject_choice_text("Choice 2") \
#				.build(),
#			ChoiceOptionBuilder.new().default(direct) \
#				.inject_choice_text("Choice 3") \
#				.build(),
#		]
#
#	var choice_statement = ChoiceStatementBuilder.new().default(direct) \
#		.inject_choice_options(choice_options) \
#		.build()
#	var choice_manager = ChoiceManagerBuilder.new().default(direct).build()
#	var program_node = ProgramNodeBuilder.new().default_test_statement(
#			direct,
#			choice_statement,
#			[mock_story_director.double()]).build()
#
#	# ----- Setup ----- #
#
#
#	program_node.execute()
#
#	asserts.is_true(choice_manager.has_ongoing_choice, "The choice selection begins")
#
#	watch(choice_manager, ""
#
#	choice_manager.select_choice(choice_options[0])
#
#	 choice_manager.has_ongoing_choice, "The choice selection begins")
#
#	asserts.is_true()
#
#	# ----- Cleanup ----- #
#
#	FracUtils.try_free(choice_statement)
#
#	# ----- Cleanup ----- #
