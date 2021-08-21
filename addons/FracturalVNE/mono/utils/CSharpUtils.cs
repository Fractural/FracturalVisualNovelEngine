namespace Fractural.Utils
{
	/// <summary>
	/// Utility class for C# related functions.
	/// </summary>
	public class CSharpUtils
	{
		public static int CombineHashCodes(int h1, int h2)
		{
			return ((h1 << 5) + h1) ^ h2;
		}
	}
}