package hots.instances;
import hots.classes.Read;
import hots.classes.ReadAbstract;

import scuts.Scuts;

class ArrayReadImpl<T> extends ReadAbstract<Array<T>> {
  
  public var readT:Read<T>;
  
  public function new (readT:Read<T>) {
    this.readT = readT;
  }
  
  override public function read (v:String):Array<T> {
    return Scuts.notImplemented();
  }
}

typedef ArrayRead = haxe.macro.MacroType<[hots.macros.TypeClasses.createProvider(ArrayReadImpl)]>;