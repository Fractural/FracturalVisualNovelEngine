using Godot;
using System;

namespace Fractural.VisualNovelEngine
{
    public interface ISceneManager : IGDScriptWrapper
    {
        event Action<Node> NodeAdded;
        event Action<Node> NodeRemoved;
        event Action<Node> SceneLoaded;
        event Action<Node> SceneReadied;

        bool IsSelfContained
        { get; set; }
        bool AutoLoadInitialScene { get; set; }
        PackedScene InitialScene { get; set; }
        Node CurrentScene { get; set; }
        Node Root { get; }
        void GotoInitialScene();
        void GotoScene(PackedScene scene);
        void GotoScene(string scenePath);
        void TransitionToScene(PackedScene scene);
        void TransitionToScene(string scene);
    }

    public class SceneManagerWrapper : Godot.Reference, ISceneManager, IGDScriptWrapper
    {
        public event Action<Node> NodeAdded;
        public event Action<Node> NodeRemoved;
        public event Action<Node> SceneLoaded;
        public event Action<Node> SceneReadied;

        public Godot.Object Source { get; private set; }

        public SceneManagerWrapper(Godot.Object source)
        {
            Source = source;
            source.Connect("node_added", this, nameof(OnNodeAdded));
            source.Connect("node_removed", this, nameof(OnNodeRemoved));
            source.Connect("scene_loaded", this, nameof(OnSceneLoaded));
            source.Connect("scene_readied", this, nameof(OnSceneReadied));
        }

        private void OnNodeAdded(Node node) => NodeAdded?.Invoke(node);
        private void OnNodeRemoved(Node node) => NodeRemoved?.Invoke(node);
        private void OnSceneLoaded(Node scene) => SceneLoaded?.Invoke(scene);
        private void OnSceneReadied(Node scene) => SceneReadied?.Invoke(scene);

        public bool IsSelfContained
        {
            get => Source.Get<bool>("is_self_contained");
            set => Source.Set("is_self_contained", value);
        }

        public bool AutoLoadInitialScene
        {
            get => Source.Get<bool>("auto_load_initial_scene");
            set => Source.Set("auto_load_initial_scene", value);
        }

        public PackedScene InitialScene
        {
            get => Source.Get<PackedScene>("initial_scene");
            set => Source.Set("initial_scene", value);
        }

        public Node CurrentScene
        {
            get => Source.Get<Node>("current_scene");
            set => Source.Set("current_scene", value);
        }

        public Node Root => Source.Call<Node>("get_root");

        public void GotoInitialScene() => Source.Call("goto_initial_scene");

        public void GotoScene(PackedScene scene) => Source.Call("goto_scene", scene);

        public void GotoScene(string scenePath) => Source.Call("goto_scene", scenePath);

        public void TransitionToScene(PackedScene scene) => Source.Call("transition_to_scene", scene);

        public void TransitionToScene(string scenePath) => Source.Call("transition_to_scene", scenePath);
    }
}