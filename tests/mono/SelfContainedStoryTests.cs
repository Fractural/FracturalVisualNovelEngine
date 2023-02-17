using System.IO;
using Godot;
using System.Linq;
using Fractural.VisualNovelEngine;
using System;
using System.Threading.Tasks;

namespace Test
{
    [Title("Mono SelfContainedStory")]
    public class SelfContainedStoryTests : WAT.Test
    {
        [Test]
        public async Task WhenRunSelfContainedStory_ShouldCreateStoryScene()
        {
            Describe("When running a self contained story, should create story scene.");
            StoryRunner storyRunner = GD.Load<PackedScene>("res://addons/FracturalVNE/_modules/mono/mono_self_contained_story.tscn").Instance<StoryRunner>();
            AddChild(storyRunner);

            Assert.IsNotNull(storyRunner.SceneManager, "SceneManager exists.");
            Assert.IsNotNull(storyRunner.StorySaveManager, "StorySaveManager exists.");

            storyRunner.Run("res://demo/testing/integration_test.story");

            await UntilEvent(storyRunner.SceneManager, nameof(storyRunner.SceneManager.SceneReadied), 0.2f,
                new Action<Node>((scene) =>
                {
                    GD.Print(scene);
                })
            );

            Assert.IsEqual(storyRunner.SceneManager.CurrentScene.Filename, "res://addons/FracturalVNE/core/story/story.tscn", "CurrentScene has been set to Story.tscn");
            Assert.IsNotNull(storyRunner.SceneManager.Root.GetNode("Story"), "Story scene has been instantiated.");
        }
    }
}