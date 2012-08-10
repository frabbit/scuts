package hots;
import hots.box.ArrayBox;
import hots.box.FunctionBox;
import hots.box.OptionBox;
import hots.box.ValidationBox;
import hots.instances.ArrayOf;
import hots.instances.ArrayTOf;
import hots.instances.FunctionOfOf;
import hots.instances.OptionOf;
import hots.instances.OptionTOf;
import hots.instances.ValidationOf;
import hots.instances.ValidationTOf;
import scuts.core.types.Option;
import scuts.core.types.Validation;

// Option Casts

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

// Validation Casts

class ValidationOf_Casts
{
  public static inline function implicitUpcast <F,S>(a:Validation<F,S>):ValidationOf<F,S> 
  {
    return ValidationBox.box(a);
  }
  
  public static inline function implicitDowncast <F,S>(a:ValidationOf<F,S>):Validation<F,S>
  {
    return ValidationBox.unbox(a);
  }
}

class ValidationOf_Function_Casts
{
  public static inline function implicitUpcast <F,S,X>(a:X->Validation<F,S>):X->ValidationOf<F,S> 
  {
    return ValidationBox.boxF(a);
  }
  
  public static inline function implicitDowncast <F,S,X>(a:X->ValidationOf<F,S>):X->Validation<F,S>
  {
    return ValidationBox.unboxF(a);
  }
}

class ValidationTOf_Function_Casts 
{
  public static inline function implicitUpcast <M,F,S,X>(a:X->Of<M, Validation<F,S>>)
  {  
    return ValidationBox.boxFT(a);
  }
  public static inline function implicitDowncast <M,F,S,X>(a:X->ValidationTOf<M,F,S> ):X->Of<M, Validation<F,S>> 
  {
    return ValidationBox.unboxFT(a);
  }
}

class ValidationTOf_Casts
{
  public static inline function implicitUpcast <M, F,S>(a:Of<M, Validation<F,S>>):ValidationTOf<M,F,S>
  {
    return ValidationBox.boxT(a);
  }
  
  public static inline function implicitDowncast <M, F,S>(a:ValidationTOf<M,F,S>):Of<M, Validation<F,S>>
  {
    return ValidationBox.unboxT(a);
  }
}


// Array Casts

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




class ArrayTOf_Function_Casts
{
  public static inline function implicitUpcast <M,T,X>(a:X->Of<M, Array<T>>)
  {
    return ArrayBox.boxFT(a);
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
