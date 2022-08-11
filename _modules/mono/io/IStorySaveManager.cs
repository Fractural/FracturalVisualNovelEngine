using Godot.Collections;
using Godot;

namespace Fractural.FracVNE.IO
{
	public interface IStorySaveManager
	{
		void SaveStateToSlot(ISaveState saveState, int saveSlotId);
		ISaveState GetSaveSlot(int saveSlotId);
		bool HasSaveSlot(int saveSlotId);
		void PreloadSaveSlots();
	}
}