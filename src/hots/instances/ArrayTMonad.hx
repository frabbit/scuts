package hots.instances;
import scuts.core.extensions.ArrayExt;
import hots.classes.Monad;
import hots.classes.MonadT;
import hots.wrapper.MTVal;
import hots.dev.DebugMonad;
import hots.wrapper.Monadic;
import hots.wrapper.Mark;
import hots.instances.FunctorArrayT;
import hots.wrapper.MVal;

using scuts.core.extensions.Function1Ext;

private typedef MAT = MonadArrayT;
private typedef MA = MonadArray;

class MonadArrayT 
{
  public static function box <M,A>(v:MVal<M, Array<A>>) return FunctorArrayT.box(v)
  public static function unbox <M,A>(v:MTValArray<M, A>) return FunctorArrayT.unbox(v)
  
  public static function get <M>(cl:Monad<M>):MonadArrayTImpl<M> return new MonadArrayTImpl(cl)
}

private class MonadArrayTImpl<M> extends MonadTDefault<M, MarkArray> {
  
  public function new (cl:Monad<M>) {
    super(new FunctorArrayTImpl(cl), cl);
  }

  
  override public function flatMap<A,B>(val:MTValArray<M,A>, f: A->MTValArray<M,B>):MTValArray<M,B> 
  {
    var fmapped = outerMonad.flatMap(MAT.unbox(val), 
      function (a) {
        var mapped = MA.get.map(f, MA.box(a));
        var unboxed = MA.unbox(mapped);
        
        var res = [];
        for (e in unboxed) {
          outerMonad.map(function (x:Array<B>) {
            for (a in x) {
              res.push(a);
            }
          },MAT.unbox(e));
        }
        return outerMonad.ret(res);//res;
      });
    return MAT.box(fmapped);
  }
  
  override public function lift <A>(val:MVal<M,A>):MTValArray<M,A>
  {
    return MAT.box(outerMonad.map(function (x) return [x], val));
  }
}