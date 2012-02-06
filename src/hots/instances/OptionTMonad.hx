package hots.instances;

import hots.boxing.BoxOptionT;
import scuts.core.types.Option;
import hots.instances.FunctorOptionT;
import scuts.core.extensions.OptionExt;
import hots.classes.Monad;
import hots.classes.MonadT;
import hots.instances.MonadOptionT;
import hots.wrapper.MTVal;
import hots.dev.DebugMonad;
import hots.wrapper.Monadic;
import hots.wrapper.Mark;
import hots.wrapper.MVal;

using scuts.core.extensions.Function1Ext;

private typedef MOT = MonadOptionT;
private typedef MO = MonadOption;

class MonadOptionT 
{
  public static function box <M,A>(v:MVal<M, Option<A>>):MTValOption<M, A> return BoxOptionT.box(v)
  
  public static function unbox <M,A>(v:MTValOption<M, A>):MVal<M, Option<A>> return BoxOptionT.unbox(v)
  
  public static function boxF <M,A,B>(f:A->MVal<M, Option<B>>):A->MTValOption<M, B> return BoxOptionT.boxF(f)
  
  public static function unboxF <M,A,B>(f:A->MTValOption<M, B>):A->MVal<M, Option<B>> return BoxOptionT.unboxF(f)
  
  
  public static function get <M>(cl:Monad<M>):MonadOptionTImpl<M> return new MonadOptionTImpl(cl)
}

private class MonadOptionTImpl<M> extends MonadTDefault<M, MarkOption> {
  
  public function new (cl:Monad<M>) {
    super(new FunctorOptionTImpl(cl), cl);
  }

  
  override public function flatMap<A,B>(val:MTValOption<M,A>, f: A->MTValOption<M,B>):MTValOption<M,B> 
  {
    var fmapped = outerMonad.flatMap(MOT.unbox(val), 
      function (a) {
        var mapped = MO.get.map(f, MO.box(a));
        var unboxed = MO.unbox(mapped);
        
        
        var res = switch (unboxed) {
          case Some(v): 
            var r = None;
            outerMonad.map(function (x:Option<B>) r = x, MOT.unbox(v));
            r;
            
          case None: None;
        }
        
        return outerMonad.ret(res);//res;
      });
    return MOT.box(fmapped);
  }
  
  override public function lift <A>(val:MVal<M,A>):MTValOption<M,A>
  {
    return MOT.box(outerMonad.map(function (x) return Some(x), val));
  }
}