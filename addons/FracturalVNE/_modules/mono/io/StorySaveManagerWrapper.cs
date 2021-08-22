using System.Collections.Generic;
using Fractural.GDScriptWrappers;
using Godot;
using Godot.Collections;
using Fractural.Utils;

namespace Fractural.FracVNE.IO
{
	public class StorySaveManagerWrapper : Node, IStorySaveManager, IGDScriptWrapper
	{
		[Export]
		private NodePath sourcePath;
		public Object Source => GetNode(sourcePath);

		public ISaveState GetSaveSlot(int saveSlotId) => new SaveStateWrapper(Source.Call<Godot.Object>("get_save_slot", saveSlotId));
		public bool HasSaveSlot(int saveSlotId) => Source.Call<bool>("has_save_slot", saveSlotId);
		public void PreloadSaveSlots() => Source.Call("preload_save_slots");
		public void SaveStateToSlot(ISaveState saveState, int saveSlotId) => Source.Call("save_state_to_slot", saveState, saveSlotId); 
	}
}