using Godot;
using System;
using System.Collections.Generic;
using Fractural.Utils;

namespace Fractural.DependencyInjection
{
	public class DIContainer : Node
	{
		[Signal]
		public delegate void Readied();
		
		[Export]
		public bool IsSelfContained { get; set; }
		public List<Godot.Object> GDScriptServices;
		public List<object> CSharpServices;
		public SceneManager SceneManager;

		[Export]
		private NodePath sceneManagerPath;
		[Export]
		private NodePath dependenciesHolderPath;

		public override async void _Ready()
		{
			SceneManager = GetNode<SceneManager>(sceneManagerPath);

			await ToSignal(GetTree(), "idle_frame");
			
			if (!IsSelfContained)
			{
				Node root = GetTree().Root;
				GetParent().RemoveChild(this);
				root.AddChild(this);
			}

			SceneManager.GotoInitialScene();
		}

		public void AddDependency(Godot.Object dependency)
		{
			// Supports both GDScript and CSharp wrappers.
			if (dependency.GetScript() is GDScript)
			{
				GDScriptServices.Add(dependency);
				if (GDScriptUtils.IsType(dependency, "CSharpWrapper"))
					CSharpServices.Add(dependency.Get("source"));
			} else if (dependency.GetScript() is CSharpScript)
			{
				CSharpServices.Add(dependency);
				if (dependency is IGDScriptWrapper)
					GDScriptServices.Add((dependency as IGDScriptWrapper).Source);
			}
		}

		public bool HasDependency(Godot.Object otherDependency)
		{
			foreach (Godot.Object dependency in GDScriptServices)
				if (dependency.GetType() == otherDependency.GetType())
					return true;
			return false;
		}

		private void OnSceneLoaded(Node loadedScene)
		{
			if (!loadedScene.HasNode("Dependencies"))
				return;
			
			var dependenciesHolder = loadedScene.GetNode("Dependencies");
			var dependencyRequesters = dependenciesHolder.GetChildren();

			foreach (Node requester in dependencyRequesters)
				TryInjectDependencies(new DependencyWrapper(requester));
		}

		private void TryInjectDependencies(DependencyWrapper requester)
		{
			foreach (Godot.Object injectableDependency in GDScriptServices)
				if (GDScriptUtils.IsType(injectableDependency, requester.DependencyName))
				{
					requester.DependencyObject = injectableDependency;
					break;
				}
			foreach (object injectableDependency in CSharpServices)
				if (injectableDependency.GetType().FullName == requester.DependencyName)
				{
					requester.CSharpDependencyObject = injectableDependency;
					break;
				}
		}
	}

	public interface IGDScriptWrapper
	{
		Godot.Object Source { get; }
	}
}