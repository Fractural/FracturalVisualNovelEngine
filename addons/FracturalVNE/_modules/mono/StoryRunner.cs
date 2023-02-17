using Fractural.VisualNovelEngine.IO;
using Godot;
using System;

namespace Fractural.VisualNovelEngine
{
    // Wrapper for story_runner.gd
    public class StoryRunner : Node, IGDScriptWrapper
    {
        public ISceneManager SceneManager { get; set; }
        public IStorySaveManager StorySaveManager { get; set; }

        public string StoryFilePath
        {
            get => Source.Get<string>("story_file_path");
            set => Source.Set("story_file_path", value);
        }

        public PackedScene QuitToScene
        {
            get => Source.Get<PackedScene>("quit_to_scene");
            set => Source.Set("quit_to_scene", value);
        }

        public Godot.Object Source { get; private set; }

        [Export]
        private NodePath gdStoryRunnerPath;
        [Export]
        private NodePath sceneManagerPath;
        [Export]
        private NodePath storySaveManagerPath;

        public override void _Ready()
        {
            Source = GetNode(gdStoryRunnerPath);
            SceneManager = new SceneManagerWrapper(GetNode(sceneManagerPath));
            StorySaveManager = new StorySaveManagerWrapper(GetNode(storySaveManagerPath));
        }

        public void Run(string storyFilePath = "", PackedScene quitToScene = null) => Source.Call("run", storyFilePath, quitToScene);
    }
}