using Godot.Collections;
using Godot;

namespace Fractural.FracVNE.IO
{
	public interface ISaveState
	{
		int StartingNodeId { get; set; }
		Dictionary StoryTreeState { get; set; }
		string StoryFilePath { get; set; }
		Dictionary SavedDate { get; set; }
		Texture Thumbnail { get; set; }
	}
}