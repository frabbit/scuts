package hots;
import hots.box.ArrayBox;
import hots.box.FunctionBox;
import hots.box.OptionBox;
import hots.instances.ArrayOf;
import hots.instances.ArrayTOf;
import hots.instances.FunctionOfOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import scuts.core.types.Option;


class OptionOf_Casts
{
  public static inline function implicitUpcast <T>(a:Option<T>):OptionOf<T> 
  {
    return OptionBox.box(a);
  }
  
  public static inline function implicitDowncast <T>(a:OptionOf<T>):Option<T>
  {
    return OptionBox.unbox(a);
  }
}

class OptionOf_Function_Casts
{
  public static inline function implicitUpcast <T,X>(a:X->Option<T>):X->OptionOf<T> 
  {
    return OptionBox.boxF(a);
  }
  
  public static inline function implicitDowncast <T,X>(a:X->OptionOf<T>):X->Option<T>
  {
    return OptionBox.unboxF(a);
  }
}




class ArrayTOf_Casts
{
  public static inline function implicitUpcast <M,T>(a:Of<M, Array<T>>):ArrayTOf<M,T> 
  {
    return ArrayBox.boxT(a);
  }
  public static inline function implicitDowncast <M,T>(a:ArrayTOf<M,T> ):Of<M, Array<T>> 
  {
    return ArrayBox.unboxT(a);
  }
  
  
}

class OptionTOf_Function_Casts 
{
  public static inline function implicitUpcast <M,T,X>(a:X->Of<M, Option<T>>)
  {  
    return OptionBox.boxFT(a);
  }
  public static inline function implicitDowncast <M,T,X>(a:X->OptionTOf<M,T> ):X->Of<M, Option<T>> 
  {
    return OptionBox.unboxFT(a);
  }
}


class ArrayTOf_Function_Casts
{
  public static inline function implicitUpcast <M,T,X>(a:X->Of<M, Array<T>>)
  {
    return ArrayBox.boxFT(a);
  }
  
}



class OptionTOf_Casts
{
  public static inline function implicitUpcast <M, T>(a:Of<M, Option<T>>):OptionTOf<M,T>
  {
    return OptionBox.boxT(a);
  }
  
  public static inline function implicitDowncast <M, T>(a:OptionTOf<M,T>):Of<M, Option<T>>
  {
    return OptionBox.unboxT(a);
  }
  
  
}


class ArrayOf_Casts
{
  public static inline function implicitUpcast <T>(a:Array<T>):ArrayOf<T> 
  {
    return ArrayBox.box(a);
  }
  
  public static inline function implicitDowncast <T>(a:ArrayOf<T>):Array<T> 
  {
    return ArrayBox.unbox(a);
  }
}

class ArrayOf_Function_Casts
{
  public static inline function implicitUpcast <X,T>(a:X->Array<T>):X->ArrayOf<T>
  {
    return ArrayBox.boxF(a);
  }
  public static inline function implicitDowncast <X,T>(a:X->ArrayOf<T>):X->Array<T>
  {
    return ArrayBox.unboxF(a);
  }
}

class Function_Arrow_Casts
{
  public static inline function implicitUpcast <A,B>(f:A->B):FunctionOfOf<A, B>
  {
    return FunctionBox.asArrow(f);
  }
  public static inline function implicitDowncast <A,B>(f:FunctionOfOf<A, B>):A->B
  {
    return FunctionBox.runArrow(f);
  }
}
