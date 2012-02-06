package hots.instances;
import hots.boxing.BoxOptionT;
import hots.classes.Functor;
import hots.classes.FunctorT;
import hots.wrapper.Mark;
import hots.wrapper.MVal;
import hots.wrapper.MTVal;
import scuts.core.types.Option;
using hots.extensions.Monadics;

import scuts.core.extensions.Function1Ext;
import scuts.core.extensions.Function2Ext;

class FunctorOptionT 
{
  public static function box <M,A>(v:MVal<M, Option<A>>):MTValOption<M, A> return BoxOptionT.box(v)
  
  public static function unbox <M,A>(v:MTValOption<M, A>):MVal<M, Option<A>> return BoxOptionT.unbox(v)
  
  public static function boxF <M,A,B>(f:A->MVal<M, Option<B>>):A->MTValOption<M, B> return BoxOptionT.boxF(f)
  
  public static function unboxF <M,A,B>(f:A->MTValOption<M, B>):A->MVal<M, Option<B>> return BoxOptionT.unboxF(f)
}


private typedef FO = FunctorOption;
private typedef FOT = FunctorOptionT;

class FunctorOptionTImpl<M, Func:Functor<M>> implements FunctorT<M,MarkOption> {
  
  var outer:Func;
  
  public function new (cl:Func) 
  {
    this.outer = cl;
  }

  public function map<A,B>(f:A->B, fa:MTValOption<M, A>):MTValOption<M, B> {
    
    return FOT.box(outer.map(function (x) {
      return FO.unbox(FO.get.map(f, FO.box(x)));
    },FOT.unbox(fa)));
  }
}