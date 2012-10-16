package ;

// hots classes
using hots.ImplicitInstances;
using hots.ImplicitCasts;

// Javascript API
import js.JQuery;
import js.Lib;
import js.Dom;

// Import der Do-Syntax
import hots.Do;
// other classes
import scuts.core.Unit;

// Promises
import scuts.core.Promise;

using scuts.core.Promises;

class Animation 
{
  // Bewegt das Element mit der Id "elemId" auf die neue Position (newX, newY).
  // Der Animationsprozess wird von der Javascript Bibliothek JQuery durchgeführt.
  // Diese Bewegung wird in Form eines asynchronen Prozess als Promise zurückgegeben.
  public static function move (elemId:String, newX:Int, newY:Int):Promise<Unit> 
  {
    var p = new Promise();
    new JQuery("#" + elemId).animate( { left : newX, top:newY }, 1000, function () p.complete(Unit));
    return p;
  }
  
  // Skaliert das Element mit der Id "elemId" auf die neue Größe (newWidth, newHeight)
  // Die Implementierung basiert wie auch "move" auf JQuery
  public static function resize (elem:String, newWidth:Int, newHeight:Int):Promise<Unit> 
  {
    var p = new Promise();
    new JQuery("#" + elem).animate( { width : newWidth, height:newHeight }, 1000, function () p.complete(Unit));
    return p;
  }
  
  // Erzeugt einen Html Div-Container in Form einer Box mit den übergebenen Eigenschaften
  public static function createBox (id:String, color:String, x:Int, y:Int, width:Int, height:Int) 
  {
    var elem = Lib.document.createElement("div");
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
    // Referenz auf das Body Element des Html-Doms
    var body = Lib.document.body;

    // Erzeugen von vier unterschiedlichen Boxen und 
    // Einhängen dieser in den HTML-Dom
    body.appendChild(createBox("redBox", "#FF0000", 0,0, 100, 100));
    body.appendChild(createBox("blueBox", "#0000FF", 0,100, 100, 100));
    body.appendChild(createBox("greenBox", "#00FF00", 100,0 , 100, 100));
    body.appendChild(createBox("cyanBox", "#00FFFF", 100,100 , 100, 100));

    // Der Animationsvorgang
    var anim = Do.run(
      move("cyanBox", 300, 300),
      move("greenBox", 200, 10),
      move("blueBox", 10,10).zip(move("greenBox", 20, 20)),
      resize("redBox", 200, 200),
      pure(Unit)
    );
    // sobald die Animation vollständig durchgeführt wurde, wird "animation complete" ausgegeben.
    anim.onComplete(function (_) trace("animation complete"));
    
    //anim.onCancelled(function () trace("animation cancelled"));
  }
}