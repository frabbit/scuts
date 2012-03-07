package scuts;
import haxe.PosInfos;

class Log 
{
	public static function traced <T>(v:T, ?show:T->String, ?pos:PosInfos):T 
  {
    #if debug
    var t = if (show != null) show(v) else Std.string(v);
    haxe.Log.trace(t, pos);
    #end
    return v;
  }
	
}