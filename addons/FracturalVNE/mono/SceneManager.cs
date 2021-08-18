using Godot;
using System;

// Manages transitions between scenes.
public class SceneManager : Node
{
	public class SceneLoadedArgs : EventArgs
	{
		public Node Scene { get; set; }
	}

	public class SceneReadiedArgs : EventArgs
	{
		public Node Scene { get; set; }
	}

	[Signal]
	public delegate void SceneLoadedSignal(Node loadedScene);
	public event EventHandler<SceneLoadedArgs> SceneLoaded;

	[Signal]
	public delegate void SceneReadiedSignal(Node readiedScene);
	public event EventHandler<SceneReadiedArgs> SceneReadied;

	[Export]
	public PackedScene InitialScene { get; set; }

	public void GotoInitialScene()
	{
		if (InitialScene != null)
		{
			GotoScene(InitialScene);
		}
	}

	public void GotoScene(PackedScene scene)
	{
		GetTree().CurrentScene.QueueFree();

		Node instance = scene.Instance();

		OnSceneLoaded(new SceneLoadedArgs { Scene = instance});

		GetTree().Root.AddChild(instance);
		GetTree().CurrentScene = instance;

		OnSceneReadied(new SceneReadiedArgs { Scene = instance});
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

	protected void OnSceneLoaded(SceneLoadedArgs args)
	{
		EmitSignal("SceneReadiedSignal");
		SceneLoaded?.Invoke(this, args);
	}

	protected void OnSceneReadied(SceneReadiedArgs args)
	{
		EmitSignal("SceneLoadedSignal");
		SceneReadied?.Invoke(this, args);
	}
}