
package scuts.core.tools;



#if macro
import haxe.ds.StringMap;
//import haxe.macro.Context;
import haxe.PosInfos;
import haxe.Timer;
import scuts.core.Arrays;
import scuts.core.Floats;
import scuts.core.Ints;
import scuts.core.Iterables;
import scuts.core.Iterators;
import scuts.core.Strings;
import scuts.core.Unit;

using scuts.core.Options;
using scuts.core.Maps;
using scuts.core.Arrays;
using scuts.core.Strings;

typedef StatsEntry = { times : Array<Float>, subs:StringMap<StatsEntry>};

typedef Stats = StringMap<StatsEntry>;
typedef SingleStats = StringMap<{ times : Array<Float>, infos: StringMap<Int>, bruttoTimes:Array<Float>, callers: StringMap<Int>}>;

typedef CallStack = Array<{ id: String, start:Float, stamp:Float, time: Float, profilerTime : Float, subTime:Float, isInfo:Bool}>;


enum ProfilerError {
  PopOnEmptyStack;
  NegativeTime;
}

class Profiler {
  
  

  public var stackIds : StringMap<Int>;
  public var callStack : CallStack;

  public var profilerTime:Float;

  public var r1:Float;
  public var r2:Float;

  public var singleStats : SingleStats;
  
  public var stats : Stats;

  public function new () 
  {
    stackIds = new StringMap();
    r1 = 0.0;
    r2 = 0.0;
    profilerTime = 0.0;
  	callStack = [];
    singleStats = new StringMap();
    stats = new StringMap();
  }

  public function pushId (id:String) {
    if (!stackIds.exists(id)) {
      stackIds.set(id, 1);
    } else {
      stackIds.set(id, stackIds.get(id)+1);
    }
  }
  public function hasId (id:String) {
    return stackIds.exists(id);
  }
  public function removeId (id:String) {
    if (!stackIds.exists(id)) {
      throw "cannot remove";
    } else {
      var val = stackIds.get(id);
      if (val == 1) {
        stackIds.remove(id);
      } else {
        stackIds.set(id, val-1);
      }
      
    }
  }

  public function pushPop(?id:String, ?posInfos:PosInfos) 
  {
    push(id, posInfos, true);
    pop();
  }



  public function pushPopWithVal<X>(val:X, ?id:String, ?posInfos:PosInfos):X 
  {
    pushPop(id, posInfos);
    return val;
  }

  public function pop() 
  {
    if (callStack.length > 0) 
    {
      
      var t = stamp();
      var current = callStack[callStack.length-1];

      var prev = if (callStack.length > 1) Some(callStack[callStack.length-2].id) else None;
      
      var runTime = (t-current.stamp)+current.time;

      removeId(current.id);

      var isRecursive = hasId(current.id);

      var bruttoTime = if (isRecursive) 0.0 else (t - current.start) - current.profilerTime;

      if (bruttoTime < 0.0) throw NegativeTime;

      var path = callStackToPath(callStack);

      
      if (callStack.length > 1 && current.isInfo) {
        addNormalStatsInfo(callStack[callStack.length-2].id, current.id);
      } else {
        addNormalStats(current.id, runTime, bruttoTime, prev);
      }

      

      callStack.pop();
      if (callStack.length > 0) 
      {
        var popTime = stamp()-t;
        this.profilerTime += popTime;
        var newNext = callStack[callStack.length-1];
        newNext.stamp = stamp();
        newNext.profilerTime += current.profilerTime + popTime;

      }
    } else {
      throw PopOnEmptyStack;
    }
  }

  public function push(?id:String, ?posInfos:PosInfos, ?isInfo:Bool = false) 
  {
    var t = stamp();
    if (callStack.length > 0) {
      
      var current = callStack[callStack.length-1];

      var runTime = (t-current.time);

      current.time += t - current.stamp;
    }

    var callId = posInfos.className + "." + posInfos.methodName + (if (id != null) "#" + id else "");
    var usedId = if(isInfo) id else callId;
    pushId(usedId);
    var stamp = stamp();
    var pushTime = stamp - t;
    this.profilerTime += pushTime;
    callStack.push({id: usedId, start : t, time:0.0, stamp:stamp, profilerTime : pushTime, subTime: 0.0, isInfo : isInfo });

  }

  
  public function singleStatsToString (s:SingleStats, prefixToRemove = "") 
  {
    function withoutPrefix (x) return if (x != "" && x.startsWith(prefixToRemove)) x.substr(prefixToRemove.length) else x;

    function statsEntryToString(totalCallTime:Float, id:String, x:{ callTime : Float, bruttoTime : Float, calls : Int, infos: StringMap<Int>, callers: StringMap<Int>}) 
    {

      var percent = Strings.padLeft(Std.string(Std.int((x.callTime / totalCallTime) * 100)), " ", 3) + "%";
      

      //trace(x.infos);
      var infosStr = x.infos.fold("", function (acc, k, v) return acc + (if (acc == "") "" else ", ") + k + "(" + v + ")");
      
      var singles = "";
      var sKeys = x.callers.keys();
      var first = true;
      for (k in sKeys) {
        if (first) {
          first = false;
        } else {
          singles += "\n  ";
        }
        singles += x.callers.get(k) + "x " + withoutPrefix(k);
      }
      singles += "";
      var fformat = Floats.formatToPrecision.bind(_, 5);
      return 
        " [calls: " + Strings.padLeft(Std.string(x.calls), " ", 4)
           + " time ( " + percent + " ): " + fformat(x.bruttoTime) + " / " + fformat(x.callTime) + " tpc: " + fformat(x.bruttoTime/x.calls) + "/" + fformat(x.callTime/x.calls)
           + (if (infosStr.length > 0) " infos: " + infosStr else "") + "]" + "\n  " + singles;

      

    }
    var res = "";
    var longest = 0;
    var keys = Iterators.toArray(s.keys());
    keys.sort(function (x,y) return Strings.compareInt(withoutPrefix(x), withoutPrefix(y)));
    for (x in keys) {
      longest = Ints.max(longest, withoutPrefix(x).length);
    }

    var mapped = s.mapElems(function (e) {
      return { 
        bruttoTime : Arrays.foldLeft(e.bruttoTimes, 0.0, Floats.plus),
        callTime : Arrays.foldLeft(e.times, 0.0, Floats.plus),
        calls : e.times.length,
        infos : e.infos,
        callers : e.callers
      }
    });

    var totalCallTime = mapped.foldElems(0.0, function (a, c) return a + c.callTime);
    res += "\ntotal time: " + Floats.formatToPrecision(totalCallTime, 5) + "\n\n";
    for (x in keys) {
      res += "\n\n" + Strings.padRight(withoutPrefix(x), " ", longest)  + " " + statsEntryToString(totalCallTime, x, mapped.get(x));
    }
    return res + "\n";
  }
  
  function toString (subs:Array<String>, calls:Int, callTime:Float, subTime:Float, id:String ) 
  {
    var buf = [];
    var timeWithoutSubs = callTime - subTime;
    if (Strings.startsWith(id, "@")) {
      buf.push("[calls: " + calls + "]");
      
      
    } else {
      buf.push(" [calls: " + calls
         + " time: " + callTime + "/" + timeWithoutSubs + " tpc: " + (callTime/calls) + "]");
      for (s in subs) {
        buf.push(s);
      }

    }
    return buf;
  }

  function mkSubsString(entries:Array<{k:String, v:Array<String>, time:Float}>, indent:String, longest:Int)
  {
    var subs = [];
    for (e in entries) {
      subs.push("\n");
      subs.push(indent);
      subs.push(Strings.padRight(e.k, " ", longest));
      subs.push(" ");
      for (x in e.v) {
        subs.push(x);
      }
    }
    return subs;
  }
  
  function getLongestString (a:Iterable<String>):Int 
  {
    return Iterables.foldLeft(a, 0, function (acc, cur) return Ints.max(acc, cur.length));
  }
  
  
  function statsEntryToString(id:String, x:StatsEntry, indent:String, indentStep:String ) 
  {
    var calls = x.times.length;

    var callTime = Arrays.foldLeft(x.times, 0.0, Floats.plus);

    var keys = [for (k in x.subs.keys()) k];

    return if (keys.length > 0) 
    {
      var longest = getLongestString(keys);
      
      var entries = [for (k in keys) statsEntryToString(k, x.subs.get(k), indent + indentStep, indentStep)];
      var subTime = entries.foldLeft(0.0, function (acc, cur:{ k : String, v : Array<String>, time:Float}) return acc + cur.time);
      { k : id, v: toString(mkSubsString(entries, indent, longest), calls, callTime, subTime, id), time : callTime}
        
    } 
    else 
    {
      { k : id, v: toString([], calls, callTime, 0.0, id), time : callTime};
    }

  }

  public function statsToString (s:Stats) 
  {
    return statsEntryToString("", { times : [], subs : s}, "", "  ").v.join("");
  }



  public function concatStringMaps <X>(a:StringMap<X>, b:StringMap<X>, f:X->X->X):StringMap<X> 
  {
    
    var res = new StringMap();

    var ka = [for (k in a.keys()) k];
    var kb = [for (k in b.keys()) k];

    while (ka.length > 0) {
      var k = ka[0];
      ka.shift();
      if (b.exists(k)) {
        kb.remove(k);
        res.set(k, f(a.get(k), b.get(k)));
      }
    }
    while (kb.length > 0) {
      var k = kb[0];
      kb.shift();
      if (a.exists(k)) {
        ka.remove(k);
        res.set(k, f(a.get(k), b.get(k)));
      }
    }
    return res;
  }

  public function concatStats (a:Stats, b:Stats) 
  {
    return concatStringMaps(a,b, concatStatsEntries);
  }

  public function concatStatsEntries (a:StatsEntry, b:StatsEntry) 
  {
    var times = a.times.concat(b.times);

    var subs = concatStringMaps(a.subs, b.subs, concatStatsEntries);
    
    return { times : times, subs : subs };

  }  

  public function addStats (origPath:Array<String>, time:Float)
  {
    function addStats1 (stats:StatsEntry, path:Array<String>, time:Float)
    {
      return if (path.length == 0) 
      {
        stats.times.push(time);
      }
      else 
      {
        var entry = if (!stats.subs.exists(path[0])) 
        {
          var entry = { times : [], subs : new StringMap()}
          stats.subs.set(path[0], entry);
          entry;
        } 
        else 
        {
          stats.subs.get(path[0]);
        }
        
        var p = path.copy();
        p.shift();
        
        addStats1(entry, p, time);
        
        
      }
    }
    if (origPath.length > 0) 
    {
      var entry = if (!stats.exists(origPath[0])) 
      {
        var entry = { times : [], subs : new StringMap()}
        stats.set(origPath[0], entry);
        entry;
      }
      else 
      {
        stats.get(origPath[0]);
      }
      var p = origPath.copy();
      p.shift();
      addStats1(entry, p, time);
    } 
    else throw "path length must be greater than 0";
  } 

  public function addNormalStatsInfo(id:String, infoId:String) 
  {
    if (singleStats.exists(id)) 
    {
      var s = singleStats.get(id);
      if (s.infos.exists(infoId)) {
        s.infos.set(infoId, s.infos.get(infoId)+1);
      } else {
        s.infos.set(infoId, 1);        
      }

    } 
    else 
    {
      var map = new StringMap();
      map.set(infoId, 1);
      singleStats.set(id, { times : [], bruttoTimes : [], infos : map, callers : new StringMap<Int>()});
    }
  }
      
  public function addNormalStats(id:String, time:Float, bruttoTime:Float, prev:Option<String>) 
  {
    if (singleStats.exists(id)) 
    {
      var stat = singleStats.get(id);
      stat.times.push(time);
      stat.bruttoTimes.push(bruttoTime);
      switch (prev) 
      {
        case Some(v): 
          if (stat.callers.exists(v)) {
            stat.callers.set(v, stat.callers.get(v)+1);
          } else {
            stat.callers.set(v, 1);
          }
        case _:
      }
    } 
    else 
    {
      var map = new StringMap();
      switch (prev) {
        case Some(v): map.set(v, 1);
        case None:
      }
      singleStats.set(id, { times : [time], bruttoTimes:[bruttoTime], callers : map, infos : new StringMap()});
    }
  }

  public function callStackToPath (c:CallStack):Array<String> 
  {
    return [for (e in c) e.id];
  }



  

  public function popWithVal<X>(val:X) 
  {
    pop();
    return val;
  }

  public function popWithValAndInfo<X>(val:X, ?info:String, ?posInfos:PosInfos) 
  {
    pushPop(info, posInfos);
    pop();
    return val;
  }

  public function popWithInfo(?info:String, ?posInfos:PosInfos) 
  {
    pushPop(info, posInfos);
    pop();
  }

	
	
	function stamp () 
  {
		return Timer.stamp();
	}

  public function profile <X>(f:Void->X, ?id:String, ?posInfos:PosInfos) 
  {
    push(id, posInfos);
    return try 
    {
      var r = f();
      pop();
      r;
    } 
    catch (e:ProfilerError) {
      #if neko
      neko.Lib.rethrow(e);
      #else
      throw e;
      #end
    }
    catch (e:Dynamic) 
    {
      pop();
      #if neko
      neko.Lib.rethrow(e);
      #else
      throw e;
      #end
    }
  }
  

}

#end