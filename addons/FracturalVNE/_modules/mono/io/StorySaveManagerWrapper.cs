using System.Collections.Generic;
using Godot;
using Godot.Collections;

namespace Fractural.VisualNovelEngine.IO
{
    public interface IStorySaveManager
    {
        void SaveStateToSlot(ISaveState saveState, int saveSlotId);
        ISaveState GetSaveSlot(int saveSlotId);
        bool HasSaveSlot(int saveSlotId);
        void PreloadSaveSlots();
    }

    public class StorySaveManagerWrapper : IStorySaveManager, IGDScriptWrapper
    {
        public Object Source { get; private set; }

        public ISaveState GetSaveSlot(int saveSlotId) => new SaveStateWrapper(Source.Call<Godot.Object>("get_save_slot", saveSlotId));
        public bool HasSaveSlot(int saveSlotId) => Source.Call<bool>("has_save_slot", saveSlotId);
        public void PreloadSaveSlots() => Source.Call("preload_save_slots");
        public void SaveStateToSlot(ISaveState saveState, int saveSlotId) => Source.Call("save_state_to_slot", saveState, saveSlotId);

        public StorySaveManagerWrapper(Godot.Object source)
        {
            Source = source;
        }
    }
}