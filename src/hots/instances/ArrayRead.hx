package hots.instances;
import hots.classes.Read;

import scuts.Scuts;

#if macro
import hots.macros.TypeClasses;
import haxe.macro.Expr;
#end

class ArrayRead  {
  
  static var hash:Hash<Read<Dynamic>> = new Hash();
  
  @:macro public static function get <S>(readT:ExprRequire<Read<S>>):Expr {
    return TypeClasses.forType([readT], "Hash<Read<Dynamic>>", "hots.instances.ArrayReadImpl", "hots.instances.ArrayRead");
  }
}

private class ArrayReadImpl<T> implements Read<Array<T>> {
  
  public var readT:Read<T>;
  
  public function new (readT:Read<T>) {
    this.readT = readT;
  }
  
  public function read (v:String):Array<T> {
    
    return Scuts.notImplemented();
  }
}