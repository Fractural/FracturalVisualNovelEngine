using Godot;
using System;

namespace Fractural.FracVNE 
{
	// Wrapper for story_runner.gd
	public class StoryRunner : Node
	{
		public SceneManager SceneManager { get; set; }

		private String storyFilePath;
		private PackedScene quitToScene;

		[Export]
		private NodePath sceneManagerPath;

		public override void _Ready()
		{
			SceneManager = GetNode<SceneManager>(sceneManagerPath);
		}

		public void Run(String storyFilePath, PackedScene quitToScene = null)
		{
			this.storyFilePath = storyFilePath;
			this.quitToScene = quitToScene;
			SceneManager.GotoScene("res://addons/FracturalVNE/core/story/story.tscn");
		}
	}
}