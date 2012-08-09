package scuts.core;
import haxe.PosInfos;
#if macro
import neko.FileSystem;
import neko.io.FileOutput;
#end
class Log 
{
  #if macro
  static var logFile = "_scutsLog.txt";
  static var logOutput:FileOutput;
  static var logOutputCreated:Bool = false;
  private static var writeLog:Bool = #if scutsLog true #else false #end;
  #end
  
  static var traceId = 0;
  
  public static function enableScutsTrace () {
    var normal = haxe.Log.trace;
    
    haxe.Log.trace = function (msg:Dynamic, ?pos:PosInfos) 
    {
      scutsTrace(msg, normal, pos);
    }
  }
  
  public static function scutsTrace (msg:Dynamic, log:Dynamic->?PosInfos->Void, ?pos:PosInfos) 
  {
    
    
    log( { id : traceId++, val:msg },pos );
    
  }
  
  public static function logLabeled <T>(v:T, label:String, ?show:T->String, ?pos:PosInfos):T 
  {
    #if (debug)
    var t = label + " : " + if (show != null) show(v) else Std.string(v);
    debugObj(v, t, pos);
    #end
    return v;
  }
  
  public static function log <T>(v:T, ?show:T->String, ?pos:PosInfos):T 
  {
    #if (debug)
    var t = if (show != null) show(v) else Std.string(v);
    debugObj(v, t, pos);
    #end
    return v;
  }
  
  public static function logOtherLabeled <T,X>(v:T, other:X, label:String, ?show:X->String, ?pos:PosInfos):T
  {
    logLabeled(other, label, show, pos);
    return v;
  }
  
  public static function logOther <T,X>(v:T, other: X, ?show:X->String, ?pos:PosInfos):T 
  {
    log(other, show, pos);
    return v;
  }
  
  
  public static function debugObj <T,X> (e:T, msg:X, ?p:PosInfos) 
  {
    #if debug
    #if scutsDebug
    haxe.Log.trace(msg, p);
    #elseif (macro && scutsLog)
    if (writeLog && createLogFile()) {
      logOutput.writeString(p.className + "." + p.methodName + "(" + p.lineNumber + "):" + msg + "\n");
    }
    #end
    #end
    return e;
  }
  
  public static inline function debug <T,X> (e:T, debug:T->X, ?p:PosInfos) 
  {
    return debugObj(e, debug(e), p);
  }
  
  #if macro
  static function createLogFile ():Bool {
    return if (!logOutputCreated) {
      logOutput = if (!FileSystem.exists(logFile)) 
      {
        neko.io.File.write(logFile, false);
      } 
      else 
      {
        neko.io.File.append(logFile, false);
      }
      true;
    } else {
      true;
    }
    
  }
  #end
  
}