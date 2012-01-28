/**
 * @Author Heinz Hölzer
 */

package scuts.mcore.cache;

#if (!macro && !display)
#error "Class can only be used inside of macros"
#elseif (display || macro)
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Timer;
import neko.Lib;
import scuts.mcore.Print;

using StringTools;
using Lambda;


class ExprCache 
{
  var cache:Hash<Expr>;
  var times:Hash<{time:Float, calls:Int}>;
  
  var measureTimes:Bool;
  
  public function new (measureTimes:Bool) 
    {
      cache = new Hash();
      times = new Hash();
      this.measureTimes = measureTimes;
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
          
          t += 
            "  " + k.rpad(" ", 20) + " - total time: " + 
            Std.string(o.time).rpad("0", 15) + ", calls: " + 
            Std.string(o.calls).lpad(" ", 3) + ", time per call: " + 
            Std.string(perCall).rpad("0", 15) + "\n";
        }
      Lib.print(t + "\n");
    }
  
  public function call (builder:Void->Expr, key:Dynamic, callId:String, ?keyPrinter:Void->String)
    {
      var t = Timer.stamp();
      var id = Context.signature([key, callId]);
      if (measureTimes) 
        addTime(callId + "(signature)", Timer.stamp() - t);
      var t = Timer.stamp();
      // get expression from cache or generate it
      return 
        if (cache.exists(id)) 
          {
            var c = cache.get(id);
            if (measureTimes) addTime(callId + "(cache)", Timer.stamp() - t);
            c;
          } 
        else 
          {
            var expr = builder();
            if (measureTimes) addTime(callId, Timer.stamp() - t);
            // print the generated expression if a keyPrinter is passed
            if (keyPrinter != null) 
              {
                Lib.println("-----------------------------");
                Lib.println(callId + ": " +  keyPrinter() + "\n");
                Lib.println("--->\n");
                Lib.println(Print.exprStr(expr).toString());
                Lib.println("-----------------------------");
              }
            cache.set(id, expr);
            expr;
          }

    }
}

#end