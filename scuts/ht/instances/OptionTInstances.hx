
package scuts.ht.instances;


import haxe.ds.Option;
import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadEmptyAbstract;
using scuts.core.Options;

using scuts.ht.instances.OptionTInstances.OptionT;

class OptionTInstances {
  @:implicit @:noUsing
  public static function monad <M>(monadM:Monad<M>):Monad<OptionT<M,In>> return new OptionTMonadEmpty(monadM);

}

abstract OptionT<M, A>(M<Option<A>>)
{
  public function new (x:M<Option<A>>) {
    this = x;
  }

  function unwrap ():M<Option<A>> {
    return this;
  }

  public static function runT <M1,A1>(a:OptionT<M1,A1>):M1<Option<A1>>
  {
    return a.unwrap();
  }
  public static function optionT <M1,A1>(a:M1<Option<A1>>):OptionT<M1,A1>
  {
    return new OptionT(a);
  }
}



class OptionTMonadEmpty<M> extends MonadEmptyAbstract<OptionT<M,In>>
{

  var base:Monad<M>;

  public function new (base:Monad<M>)
  {
    this.base = base;
  }

  override public function flatMap<A,B>(val:OptionT<M,A>, f: A->OptionT<M,B>):OptionT<M,B>
  {
    function f1 (a) return switch (a)
    {
      case Some(v): f(v).runT();
      case None: base.pure(None);
    }

    return base.flatMap(val.runT(), f1).optionT();
  }

  override public function pure<A>(x:A):OptionT<M,A>
  {
    return base.pure(Some(x)).optionT();
  }

  override public function map<A,B>(v:OptionT<M, A>,f:A->B):OptionT<M, B>
  {
    return base.map(v.runT(),Options.map.bind(_,f)).optionT();
  }

  override public inline function empty <A>():OptionT<M,A>
  {
    return base.pure(None).optionT();
  }
}

