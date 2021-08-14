extends WAT.Test
# Tests ChoiceManager


const FracUtils = FracVNE.Utils
const StoryDirector = preload("res://addons/FracturalVNE/core/story/director/story_director.gd")
const ChoiceManagerBuilder = preload("res://tests/core/story/choice/choice_manager.builder.gd")
const ChoiceOptionBuilder = preload("res://tests/core/story_script/ast_nodes/statements/choice_statement/choice_option.builder.gd")
const ProgramNodeBuilder = preload("res://tests/core/story_script/ast_nodes/misc/program_node/program_node.builder.gd")


# TODO NOW: Finish tests for choice statement following TDD.
func title():
	return "ChoiceManager"


func test_start_choice():
	describe("When calling execute() on ChoiceStatement")
	
	# ----- Setup ----- #
	
	var choice_options = [
			ChoiceOptionBuilder.new().default(direct) \
				.inject_choice_text("Choice 1") \
				.build(),
			ChoiceOptionBuilder.new().default(direct) \
				.inject_choice_text("Choice 2") \
				.build(),
			ChoiceOptionBuilder.new().default(direct) \
				.inject_choice_text("Choice 3") \
				.build(),
		]
	
	var choice_manager = ChoiceManagerBuilder.new().default(direct).build()
	
	# ----- Setup ----- #
	
	
	choice_manager.start_choice(choice_options)
	
	asserts.is_true(choice_manager.has_ongoing_choice(), "Then there is an ongoing choice selection.")
	
	watch(choice_manager, "choice_selected")
	
	choice_manager.select_choice(choice_options[0])
	
	asserts.signal_was_emitted_with_arguments(choice_manager, "choice_selected", [choice_options[0]], "Then the correct choice was chosen.")
	asserts.is_true(choice_manager.has_ongoing_choice(), "Then there is no longer an ongoing choice selection.")
	
	
	# ----- Cleanup ----- #
	
	FracUtils.try_free(choice_manager)
	FracUtils.try_free(choice_options)
	
	# ----- Cleanup ----- #
