package;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['Easy', "Normal", "Hard", "False", "True"];

	public static var daPixelZoom:Float = 6;

	public static function difficultyFromInt(difficulty:Int):String
	{
		return difficultyArray[difficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = OpenFlAssets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolMapFile(path:String):Map<String,Bool>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
		var whatList:Map<String,Bool> = [];

		for (i in 0...daList.length)
		{
			var nowWhat = daList[i].trim().split(':'); 

			whatList.set(nowWhat[0],nowWhat[1] == '0');
		}

		return whatList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
