package hots.classes;
import scuts.Scuts;

/**
 * ...
 * @author 
 */

@:tcAbstract class ReadAbstract<T> implements Read<T> {
  public function read (v:String):T return Scuts.abstractMethod()
}
