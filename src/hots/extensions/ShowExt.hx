package hots.extensions;
import hots.classes.Show;


class ShowExt
{
  public static inline function show<T>(v1:T, s:Show<T>):String return s.show(v1) 
}