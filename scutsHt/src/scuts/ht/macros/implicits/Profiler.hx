
package scuts.ht.macros.implicits;

#if macro

import haxe.macro.Context;
import haxe.PosInfos;


class Profiler {
  #if scutsProfile
  static var profiler = 
  {
    var profiler = new scuts.core.tools.Profiler();
    Context.onGenerate(function (_) 
    {

      var date = Date.now().toString().split(" ").join("_").split(":").join("_");
      if (!sys.FileSystem.exists("log")) sys.FileSystem.createDirectory("log");
      var detail = profiler.statsToString(profiler.stats);
      var output = sys.io.File.write("log/profile_detail_" + date + ".txt", false);
      output.writeString("profilerTime: " + profiler.profilerTime);
      output.writeString(detail);
      output.close();

      var single = profiler.singleStatsToString(profiler.singleStats, "scuts.ht.macros.implicits.");
      var output = sys.io.File.write("log/profile_simple_" + date + ".txt", false);
      output.writeString("profilerTime: " + profiler.profilerTime);
      output.writeString(single);
      output.close();
      if (profiler.callStack.length > 0) {
        throw "Callstack is not empty: " + profiler.callStack; 
      }
      trace("Callstack " + profiler.callStack); 

      
    });
    profiler;
  }
  #end
  public inline static function pushPop(?id:String, ?posInfos:PosInfos) 
  {
    #if scutsProfile
    return profiler.pushPop(id, posInfos);
    #end
  }

  public inline static function pushPopWithVal<X>(val:X, ?id:String, ?posInfos:PosInfos):X 
  {
    #if scutsProfile
    return profiler.pushPopWithVal(val, id, posInfos);
    #else
    return val;
    #end
  }

  public inline static function push(?id:String, ?posInfos:PosInfos) 
  {
    #if scutsProfile
    return profiler.push(id, posInfos);
    #end
  }

  public inline static function pop() 
  {
    #if scutsProfile
    return profiler.pop();
    #end
  }

  public inline static function popWithVal<X>(val:X) 
  {
    #if scutsProfile
    return profiler.popWithVal(val);
    #else
    return val;
    #end
  }

  public inline static function popWithValAndInfo<X>(val:X, ?info:String, ?posInfos:PosInfos) 
  {
    #if scutsProfile
    return profiler.popWithValAndInfo(val, info, posInfos);
    #else
    return val;
    #end
  }

  public inline static function popWithInfo(?info:String, ?posInfos:PosInfos) 
  {
    #if scutsProfile
    return profiler.popWithInfo(info, posInfos);
    #end
  }

  public inline static function profile <X>(f:Void->X, ?id:String, ?posInfos:PosInfos) 
  {
    #if scutsProfile
    return profiler.profile(f, id, posInfos);
    #else
    return f();
    #end
  }
}

#end