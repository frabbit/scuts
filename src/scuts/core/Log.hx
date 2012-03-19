package scuts.core;
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
  
  public static inline function debugObj <T,X> (e:T, msg:X, ?p:PosInfos) 
  {
    #if (debug && scutsDebug)
    haxe.Log.trace(msg, p);
    #end
    return e;
  }
  
  public static inline function debug <T,X> (e:T, debug:T->X, ?p:PosInfos) 
  {
    return debugObj(e, debug(e), p);
  }
  
}