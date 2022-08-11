using Godot;
using System;

namespace Fractural.FracVNE
{
    public static class FracVNE
    {
        public static void RunStory(this SceneTree tree, string storyFilePath)
        {
            Node instance = GetSelfContainedStoryRunner().Instance();
            tree.Root.AddChild(instance);
            instance.Call("run", storyFilePath);
        }

        public static PackedScene GetSelfContainedStoryRunner()
        {
            return ResourceLoader.Load<PackedScene>("res://addons/FracturalVNE/plugin/self_contained_story.tscn");
        }
    }
}