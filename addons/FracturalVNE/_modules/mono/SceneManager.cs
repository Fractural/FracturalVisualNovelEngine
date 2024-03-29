using Fractural.Utils;
using Godot;
using System;

// TODO: Update the CSharp version of SceneManager with the same features from the GDScript verison.

namespace Fractural 
{
	// Manages transitions between scenes.
	public class SceneManager : Node
	{
		[Signal]
		public delegate void SceneLoaded(Node loadedScene);
		[Signal]
		public delegate void SceneReadied(Node readiedScene);
		[Signal]
		public delegate void NodeAdded(Node addedNode);
		[Signal]
		public delegate void NodeRemoved(Node removedNode);

		[Export]
		public bool IsSelfContained { get; set; }
		[Export]
		public bool AutoLoadInititalScene { get; set; }
		[Export]
		public PackedScene InitialScene { get; set; }

		public override void _Ready()
		{
			GetTree().Connect("node_added", this, nameof(OnNodeAdded));
			GetTree().Connect("node_removed", this, nameof(OnNodeRemoved));
			if (AutoLoadInititalScene)
				GotoInitialScene();
		}

		public void GotoInitialScene()
		{
			if (InitialScene != null)
				GotoScene(InitialScene);
		}

		public void GotoScene(PackedScene scene)
		{
			GetTree().CurrentScene.QueueFree();

			Node instance = scene.Instance();

			EmitSignal(nameof(SceneLoaded), instance);

			GetTree().Root.AddChild(instance);
			GetTree().CurrentScene = instance;

			EmitSignal(nameof(SceneReadied), instance);
		}

		public void TransitionToScene(PackedScene scene)
		{
			// TODO: Finish adding transitions.
			GotoScene(scene);
		}

		public void GotoScene(String scene_path)
		{
			GotoScene(ResourceLoader.Load<PackedScene>(scene_path));
		}
		
		private void OnNodeAdded(Node addedNode)
		{
			if (IsSelfContained && !addedNode.HasParent(this))
				return;
			
			EmitSignal(nameof(NodeAdded), addedNode);
		}

		private void OnNodeRemoved(Node removedNode)
		{
			if (IsSelfContained && !removedNode.HasParent(this))
				return;
			
			EmitSignal(nameof(NodeAdded), removedNode);
		}
	}
}