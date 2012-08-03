package scuts.core.time;

import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;

class StopWatch 
{

  var t:Float;
  
  public var traceEnabled(default, default):Bool;
  
  public function new() 
  {
    traceEnabled = true;
    t = Timer.stamp();
  }
  
  public function measure (?pos:PosInfos)
  {
    t = Timer.stamp() - t;
    
    if (traceEnabled) Log.trace("time: " + t, pos);
    
    t = Timer.stamp();
  }
  
}