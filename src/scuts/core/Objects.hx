package scuts.core;


class Objects
{
  public static inline function field (v:{}, field:String):Dynamic return Reflect.field(v, field);
  
  public static inline function setField  <T>(v:{}, field:String, value:Dynamic):{}
  {
    Reflect.setField(v, field, value);
    return v;
  }
  
  public static inline function hasField (v:{}, field:String):Bool return Reflect.hasField(v, field);

  public static inline function fields (v:{}, field:String):Array<String> return Reflect.fields(v);
  
}