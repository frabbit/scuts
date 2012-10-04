package hots;
import haxe.macro.MacroType;
import hots.box.ArrayBox;
import hots.box.FunctionBox;
import hots.box.ImListBox;
import hots.box.LazyBox;
import hots.box.LazyListBox;
import hots.box.OptionBox;
import hots.box.PromiseBox;
import hots.box.ValidationBox;
import hots.Of;
import hots.of.ArrayOf;
import hots.of.ArrayTOf;
import hots.of.FunctionOfOf;
import hots.of.ImListOf;
import hots.of.LazyListOf;
import hots.of.LazyTOf;

import hots.of.OptionOf;
import hots.of.OptionTOf;
import hots.of.PromiseOf;
import hots.of.ValidationOf;
import hots.of.ValidationTOf;
import scuts.core.types.ImList;
import scuts.core.types.LazyList;
import scuts.core.types.Option;
import scuts.core.types.Promise;
import scuts.core.types.Validation;


typedef LazyT_Casts         = MacroType<[hots.Gen.genCastBoxT  (function <M,T>  (x:Void->hots.Of<M, T>)   :hots.of.LazyTOf<M,T> {}, hots.box.LazyBox)]>;



typedef Validation_Casts = MacroType<[
  hots.Gen.genCastBox(function <F,S> (x:scuts.core.types.Validation<F,S>):hots.of.ValidationOf<F,S> { }, hots.box.ValidationBox)]>;

typedef Validation_Void_Casts = MacroType<[
  hots.Gen.genCastBox0(function <F,S> (x:Void->scuts.core.types.Validation<F,S>):Void->hots.of.ValidationOf<F,S> { }, hots.box.ValidationBox)]>;
  
typedef Validation_Function_Casts = MacroType<[
  hots.Gen.genCastBoxF(function <X,F,S> (x:X->scuts.core.types.Validation<F,S>):X->hots.of.ValidationOf<F,S> { }, hots.box.ValidationBox)]>;
  
typedef ValidationT_Casts         = MacroType<[
  hots.Gen.genCastBoxT(function <M,F,S>  (x:hots.Of<M, scuts.core.types.Validation<F,S>>)   :hots.of.ValidationTOf<M,F,S> { }, hots.box.ValidationBox)]>;
  
typedef ValidationT_Function_Casts         = MacroType<[
  hots.Gen.genCastBoxFT(function <M,X,F,S>  (x:X->hots.Of<M, scuts.core.types.Validation<F,S>>)   :X->hots.of.ValidationTOf<M,F,S> {}, hots.box.ValidationBox)]>;


typedef StateT_Casts         = MacroType<[
  hots.Gen.genCastBoxT(function <M,ST,X>  (x:hots.Of<M, scuts.core.types.State<ST,X>>)   :hots.of.StateTOf<M,ST,X> { }, hots.box.StateBox)]>;  

  
typedef Array_Casts          = MacroType<[hots.Gen.genCastBox   (function <T>    (x:Array<T>)               :hots.of.ArrayOf<T> {}, hots.box.ArrayBox)]>;
typedef Array_Void_Casts     = MacroType<[hots.Gen.genCastBox0  (function <T>    (x:Void->Array<T>)         :Void->hots.of.ArrayOf<T> {}, hots.box.ArrayBox)]>;
typedef Array_Function_Casts = MacroType<[hots.Gen.genCastBoxF  (function <X,T>  (x:X->Array<T>)            :X->hots.of.ArrayOf<T> {}, hots.box.ArrayBox)]>;
typedef ArrayT_Casts         = MacroType<[hots.Gen.genCastBoxT  (function <M,T>  (x:hots.Of<M, Array<T>>)   :hots.of.ArrayTOf<M,T> {}, hots.box.ArrayBox)]>;
typedef ArrayT_Function_Casts= MacroType<[hots.Gen.genCastBoxFT (function <M,T,X>(x:X->hots.Of<M, Array<T>>):X->hots.of.ArrayTOf<M,T> { }, hots.box.ArrayBox)]>;



typedef Option_Casts      = MacroType<[
  hots.Gen.genCastBox  (function <T>    (x:scuts.core.types.Option<T>)               :hots.of.OptionOf<T> {}, hots.box.OptionBox)]>;
typedef Option_Void_Casts = MacroType<[
  hots.Gen.genCastBox0 (function <T>    (x:Void->scuts.core.types.Option<T>)         :Void->hots.of.OptionOf<T> {}, hots.box.OptionBox)]>;
typedef Option_F_Casts    = MacroType<[
  hots.Gen.genCastBoxF (function <X,T>  (x:X->scuts.core.types.Option<T>)            :X->hots.of.OptionOf<T> {}, hots.box.OptionBox)]>;
typedef OptionT_Casts     = MacroType<[
  hots.Gen.genCastBoxT (function <M,T>  (x:hots.Of<M, scuts.core.types.Option<T>>)   :hots.of.OptionTOf<M,T> {}, hots.box.OptionBox)]>;
typedef OptionT_F_Casts   = MacroType<[
  hots.Gen.genCastBoxFT(function <M,T,X>(x:X->hots.Of<M, scuts.core.types.Option<T>>):X->hots.of.OptionTOf<M,T> {}, hots.box.OptionBox)]>;

  
  
typedef Promise_Casts      = MacroType<[
  hots.Gen.genCastBox  (function <T>    (x:scuts.core.types.Promise<T>)               :hots.of.PromiseOf<T> {}, hots.box.PromiseBox)]>;
typedef Promise_Void_Casts = MacroType<[
  hots.Gen.genCastBox0 (function <T>    (x:Void->scuts.core.types.Promise<T>)         :Void->hots.of.PromiseOf<T> {}, hots.box.PromiseBox)]>;
typedef Promise_F_Casts    = MacroType<[
  hots.Gen.genCastBoxF (function <X,T>  (x:X->scuts.core.types.Promise<T>)            :X->hots.of.PromiseOf<T> {}, hots.box.PromiseBox)]>;
typedef PromiseT_Casts     = MacroType<[
  hots.Gen.genCastBoxT (function <M,T>  (x:hots.Of<M, scuts.core.types.Promise<T>>)   :hots.of.PromiseTOf<M,T> {}, hots.box.PromiseBox)]>;
typedef PromiseT_F_Casts   = MacroType<[
  hots.Gen.genCastBoxFT(function <M,T,X>(x:X->hots.Of<M, scuts.core.types.Promise<T>>):X->hots.of.PromiseTOf<M,T> {}, hots.box.PromiseBox)]>;

  
  
typedef LazyList_Casts      = MacroType<[
  hots.Gen.genCastBox  (function <T>    (x:scuts.core.types.LazyList<T>)               :hots.of.LazyListOf<T> {}, hots.box.LazyListBox)]>;
typedef LazyList_Void_Casts = MacroType<[
  hots.Gen.genCastBox0 (function <T>    (x:Void->scuts.core.types.LazyList<T>)         :Void->hots.of.LazyListOf<T> {}, hots.box.LazyListBox)]>;
typedef LazyList_F_Casts    = MacroType<[
  hots.Gen.genCastBoxF (function <X,T>  (x:X->scuts.core.types.LazyList<T>)            :X->hots.of.LazyListOf<T> {}, hots.box.LazyListBox)]>;
typedef LazyListT_Casts     = MacroType<[
  hots.Gen.genCastBoxT (function <M,T>  (x:hots.Of<M, scuts.core.types.LazyList<T>>)   :hots.of.LazyListTOf<M,T> {}, hots.box.LazyListBox)]>;
typedef LazyListT_F_Casts   = MacroType<[
  hots.Gen.genCastBoxFT(function <M,T,X>(x:X->hots.Of<M, scuts.core.types.LazyList<T>>):X->hots.of.LazyListTOf<M,T> { }, hots.box.LazyListBox)]>;
  
  
  
typedef ImList_Casts      = MacroType<[
  hots.Gen.genCastBox  (function <T>    (x:scuts.core.types.ImList<T>)               :hots.of.ImListOf<T> {}, hots.box.ImListBox)]>;
typedef ImList_Void_Casts = MacroType<[
  hots.Gen.genCastBox0 (function <T>    (x:Void->scuts.core.types.ImList<T>)         :Void->hots.of.ImListOf<T> {}, hots.box.ImListBox)]>;
typedef ImList_F_Casts    = MacroType<[
  hots.Gen.genCastBoxF (function <X,T>  (x:X->scuts.core.types.ImList<T>)            :X->hots.of.ImListOf<T> {}, hots.box.ImListBox)]>;
typedef ImListT_Casts     = MacroType<[
  hots.Gen.genCastBoxT (function <M,T>  (x:hots.Of<M, scuts.core.types.ImList<T>>)   :hots.of.ImListTOf<M,T> {}, hots.box.ImListBox)]>;
typedef ImListT_F_Casts   = MacroType<[
  hots.Gen.genCastBoxFT(function <M,T,X>(x:X->hots.Of<M, scuts.core.types.ImList<T>>):X->hots.of.ImListTOf<M,T> {}, hots.box.ImListBox)]>;


// RightProjection Casts
import hots.of.EitherOf;
import scuts.core.types.Either;
import hots.box.EitherBox;


////////// NOT YET WORKING ON STATIC PLATTFORMS

#if (!cpp && !flash)

typedef RightProjection_Casts = MacroType<[
  hots.Gen.genCastBox(function <L,R> (x:scuts.core.types.Either.RightProjection<L,R>)
  :hots.of.EitherOf.RightProjectionOf<L,R> { }, hots.box.EitherBox.EitherRightProjectionBox)]>;

  
typedef RightProjection_Function_Casts = MacroType<[
  hots.Gen.genCastBoxF(function <X,L,R> (x:X->scuts.core.types.Either.RightProjection<L,R>)
  :X->hots.of.EitherOf.RightProjectionOf<L,R> { }, hots.box.EitherBox.EitherRightProjectionBox)]>;
  
#end