using Godot;
using System;

namespace Fractural.VisualNovelEngine
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

    public static class GodotExtensions
    {
        public static T Get<T>(this Godot.Object target, string name)
        {
            return (T)target.Get(name);
        }

        public static T Call<T>(this Godot.Object target, string method, params object[] args)
        {
            return (T)target.Call(method, args);
        }
    }
}