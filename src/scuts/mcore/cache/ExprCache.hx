/**
 * @Author Heinz Hölzer
 */

package scuts.mcore.cache;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.PosInfos;
import haxe.Timer;
import neko.Lib;
import scuts.core.PosInfosTools;
import scuts.mcore.Print;

using StringTools;
using Lambda;


class ExprCache 
{
  var cache:Hash<Expr>;
  var times:Hash<{time:Float, calls:Int}>;
  
  var measureTimes:Bool;
  
  var enabled:Bool;
  public function new (measureTimes:Bool) 
  {
    enabled = #if scutsCache true #else false #end;
    cache = new Hash();
    times = new Hash();
    this.measureTimes = measureTimes;
  }
  
  public function enableCache (b:Bool):ExprCache 
  {
    enabled = b;
    return this;
  }
    
  function addTime (id:String, time:Float):Void 
  {
    if (!times.exists(id)) 
    {
      times.set(id, { time: time, calls:1 } );
    }
    else 
    {
      var t = times.get(id);
      t.time += time;
      t.calls++;
    }
  }
  
    public function printOnGenerate (title:String):ExprCache
    {
      if (measureTimes) {
        Context.onGenerate(function (_) traceTimes(title));
      }
      return this;
    }
  /**
   * Prints stats and times for all calls to expression generators, signature calls and cache calls.
   * It also prints the average time for generating expressions.
   * @param  title Stats Title which is prited to the console.
   */
  public function traceTimes (title:String):Void 
  {
    
    var t = "\n" + title + ":\n------------------------------------\n";
    // sort keys
    var a:Array<String> = []; 
    for (k in times.keys()) a.push(k);
    a.sort(function (x, y) return x < y ? -1 : x > y ? 1 : 0);
    
    // create output
    
    for (k in a) 
    {
      
      var o = times.get(k);
      var perCall = o.time / o.calls;
       
      var perCallStr = if (perCall == 0) "0." + Std.string(perCall) else Std.string(perCall);
       
      t += 
        "  " + k.rpad(" ", 55) + " calls: " + 
        Std.string(o.calls).lpad(" ", 3) + " | total time: " + 
        Std.string(o.time).rpad("0", 15) + " | time per call: " + 
        perCallStr.rpad("0", 18) + "\n";
    }
    
    Lib.print(t);
   
  }
  
  public function call (builder:Void->Expr, key:Void->Dynamic, ?callId:String, ?keyPrinter:Void->String, ?posInfos:PosInfos)
  {
    
    callId = callId != null ? callId : (posInfos.className + "." + posInfos.methodName + "@" + posInfos.lineNumber + "");
    //trace(callId);
    var t = Timer.stamp();
    var id = Context.signature([key(), posInfos]);
    if (measureTimes) 
      addTime(callId + "(signature)", Timer.stamp() - t);
    var tc = Timer.stamp();
    // get expression from cache or generate it
    return if (enabled && cache.exists(id)) 
    {
      var c = cache.get(id);
      if (measureTimes) addTime(callId + "(cache)", Timer.stamp() - tc);
      c;
    } 
    else 
    {
      var t1 = Timer.stamp();
      var expr = builder();
      var t2 = Timer.stamp() - t1;
      if (measureTimes) addTime(callId, t2);
      // print the generated expression if a keyPrinter is passed
      if (keyPrinter != null) 
      {
        Lib.println("-----------------------------");
        Lib.println(callId + ": " +  keyPrinter() + "\n");
        Lib.println("--->\n");
        Lib.println(Print.expr(expr).toString());
        Lib.println("-----------------------------");
      }
      cache.set(id, expr);
      expr;
    }
  }
  
}

#end