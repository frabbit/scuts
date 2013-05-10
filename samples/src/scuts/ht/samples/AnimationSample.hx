package scuts.ht.samples;

#if !excludeHtSamples

#if js

import js.JQuery;
import js.Lib;
import js.Browser;

import scuts.core.Unit;
using scuts.core.Promises;

// import the scuts.ht context and it's implicit typeclasses
using scuts.ht.Context;

class AnimationSample 
{
  
  // Moves the html element  with the id "elemId" to a new position specified by (newX, newY).
  public static function move (elemId:String, newX:Int, newY:Int):PromiseD<Unit> 
  {
    var p = new Promise();
    new JQuery("#" + elemId).animate( { left : newX, top:newY }, 1000, p.success.bind(Unit));
    return p;
  }
  
  // scales the html element with the id elemId to it's new size
  public static function resize (elemId:String, newWidth:Int, newHeight:Int):PromiseD<Unit> 
  {
    var p = new Promise();
    new JQuery("#" + elemId).animate( { width : newWidth, height:newHeight }, 1000, p.success.bind(Unit));
    return p;
  }
  
  // Creates a div container box with the specified arguments
  public static function createBox (id:String, color:String, x:Int, y:Int, width:Int, height:Int) 
  {
    var elem = Browser.document.createElement("div");
    elem.id = id;
    elem.style.backgroundColor = color;
    elem.style.width = width + "px";
    elem.style.height = height + "px";
    elem.style.left = Std.string(x) + "px";
    elem.style.top = Std.string(y) + "px";
    elem.style.position = "absolute";
    return elem;
  }
  
  public static function main() 
  {
    var body = Browser.document.body;

    // Create four colored boxes and append them to the document body
    body.appendChild(createBox("redBox", "#FF0000", 0,0, 100, 100));
    body.appendChild(createBox("blueBox", "#0000FF", 0,100, 100, 100));
    body.appendChild(createBox("greenBox", "#00FF00", 100,0 , 100, 100));
    body.appendChild(createBox("cyanBox", "#00FFFF", 100,100 , 100, 100));

    // animation defined by monadic promises  
    var anim = Do.run(
      move("cyanBox", 300, 300),
      move("greenBox", 200, 10),
      move("blueBox", 10,10).zip(move("greenBox", 20, 20)),
      resize("redBox", 200, 200),
      pure(Unit)
    );

    anim.onComplete(function (_) trace("animation complete"));

  }
}

#end

#end