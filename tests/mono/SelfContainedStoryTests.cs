using System.IO;
using Godot;
using System;

namespace Test
{
    [Title("C# SelfContainedStory")]
    public class SelfContainedStoryTests : WAT.Test
    {
        [Test]
        public void Test()
        {
            Describe("When running a self contained story");
            // Node story = GD.Load<PackedScene>("res://addons/FracturalVNE/_modules/mono/mono_self_contained_story.tscn").Instance();
            // AddChild(story);
            Assert.IsTrue(true, "TODO: Finish writing this test");
        }
    }
}