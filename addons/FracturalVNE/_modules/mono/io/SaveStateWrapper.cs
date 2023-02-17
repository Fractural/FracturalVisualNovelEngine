using System.Collections.Generic;
using Godot;
using Fractural.VisualNovelEngine;
using Godot.Collections;

namespace Fractural.VisualNovelEngine.IO
{
    public interface ISaveState
    {
        int StartingNodeId { get; set; }
        Dictionary StoryTreeState { get; set; }
        string StoryFilePath { get; set; }
        Dictionary SavedDate { get; set; }
        Texture Thumbnail { get; set; }
    }

    public class SaveStateWrapper : ISaveState, IGDScriptWrapper
    {
        public SaveStateWrapper()
        {
            Source = (Object)GD.Load<GDScript>("res://addons/FracturalVNE/core/io/save_state.gd").New();
        }

        public SaveStateWrapper(Object source)
        {
            Source = source;
        }

        public Object Source { get; private set; }

        public int StartingNodeId
        {
            get => Source.Get<int>("starting_node_id");
            set => Source.Set("starting_node_id", value);
        }
        public Dictionary StoryTreeState
        {
            get => Source.Get<Dictionary>("story_tree_state");
            set => Source.Set("story_tree_state", value);
        }
        public string StoryFilePath
        {
            get => Source.Get<string>("story_file_path");
            set => Source.Set("story_file_path", value);
        }
        public Dictionary SavedDate
        {
            get => Source.Get<Dictionary>("saved_date");
            set => Source.Set("saved_date", value);
        }
        public Texture Thumbnail
        {
            get => Source.Get<Texture>("thumbnail");
            set => Source.Set("thumbnail", value);
        }

        public Dictionary Serialize() => (Dictionary)Source.Call("serialize");
        public Object Deserialize(Dictionary serializedObject) => (Object)Source.Call("deserialize", serializedObject);
    }
}