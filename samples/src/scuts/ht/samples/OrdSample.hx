package scuts.ht.samples;

#if !excludeHtSamples

import scuts.ht.syntax.Eqs;
import scuts.ht.syntax.EqBuilder;

import scuts.core.Tuples.*;

import scuts.core.Validations;
import scuts.core.Options;
import scuts.ht.syntax.OrdBuilder;

// bring base type classes into scope

using scuts.ht.Context;

private typedef Point = {
  x:Int,
  y:Int
}

private typedef Line = {
  from:Point,
  to:Point
}

class OrdSample 
{
  public static function main() 
  {

    // compare basic types physically

    trace(1.min_(2));
    
    trace(1.1.min_(1.2));
  

    // type classes compose

    trace(["hey"].min_([]));

    trace(Some(["b"]).max_(Some(["a"])));

    trace(Some(["a"]).max_(Some(["b"])));

    trace(tup2(1, Some(["hey"])).max_(tup2(2, Some(["hey"]))));


    // write your own compare functions

    function lineLengthSqared (x:Line) return Math.pow(x.to.x - x.from.x, 2) + Math.pow(x.to.y - x.from.y, 2);

    var lineLengthOrd = OrdBuilder.createByIntCompare(function (a:Line, b:Line) 
    {
        var lenA = lineLengthSqared(a);
        var lenB = lineLengthSqared(b);
        return lenA.compareInt_(lenB);
    });

    Ht.implicit(lineLengthOrd);

    var lineA = { from : { x : 0, y: 0}, to : { x : 0, y  : 10}};
    var lineB = { from : { x : 0, y: 0}, to : { x : 10, y : 10}};
    var lineC = { from : { x : 0, y: 0}, to : { x : 2, y : 2}};

    // type classes compose

    trace("min: " + lineA.min_(lineB));
    trace("min: " + Some(lineA).min_(Some(lineB)));
    trace("max: " + lineA.max_(lineB));
    trace("max: " + Some(lineA).max_(Some(lineB)));
    
    trace("min: " + [lineA].min_([lineB]));

    // how about lists of elements

    function minFromArray <T>(a:Array<T>, ord:Ord<T>):Option<T> 
    {
      var min:Option<T> = None;

      for (e in a) {
        min = switch (min) {
          case Some(v): Some(ord.min(v,e));
          case None:    Some(e);
        }
      }
      return min;
    }

    trace("min: " + minFromArray._([lineA, lineB, lineC]));

  }
  
}

#end