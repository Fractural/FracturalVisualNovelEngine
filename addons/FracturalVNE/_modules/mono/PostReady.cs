using Fractural.Utils;
using Godot;

namespace Fractural
{
	public class PostReady : Node
	{
		[Export]
		private NodePath sceneManagerPath;
		
		public SceneManager SceneManager { get; set; }

		public override void _Ready()
		{
			SceneManager = GetNode<SceneManager>(sceneManagerPath);
			SceneManager.Connect(nameof(SceneManager.NodeAdded), this, nameof(OnNodeAdded));
		}

		private void OnNodeAdded(Node addedNode)
		{
			if (addedNode is IPostReadiable postReadiable && !postReadiable.PostReadied)
			{
				postReadiable.PostReadied = true;
				postReadiable._PostReady();
			}
			else if (addedNode.Has("_post_readied") && !addedNode.Get<bool>("_post_readied"))
			{
				// GDScript compatability
				addedNode.Set("_post_readied", false);
				addedNode.Call("_post_ready");
			}
		}
	}

	public interface IPostReadiable
	{
		bool PostReadied { get; set; }
		void _PostReady();
	}
}