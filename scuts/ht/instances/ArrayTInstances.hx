
package scuts.ht.instances;

import scuts.ht.classes.Monad;
import scuts.ht.classes.MonadAbstract;

using scuts.core.Arrays;

using scuts.ht.instances.ArrayTInstances.ArrayT;

class ArrayTInstances {

  @:implicit @:noUsing
  public static function monad <M>(monadM:Monad<M>):Monad<ArrayT<M,In>> return new ArrayTMonad(monadM);

}

abstract ArrayT<M, A>(M<Array<A>>)
{
  public function new (x:M<Array<A>>) {
    this = x;
  }
  public function unwrap ():M<Array<A>> {
    return this;
  }

  public static function runT <M1,A1>(a:ArrayT<M1,A1>):M1<Array<A1>>
  {
    return a.unwrap();
  }
  public static function arrayT <M1,A1>(a:M1<Array<A1>>):ArrayT<M1,A1>
  {
    return new ArrayT(a);
  }
}



class ArrayTMonad<M> extends MonadAbstract<ArrayT<M,In>>
{

  var monadM:Monad<M>;

  public function new (monadM:Monad<M>)
  {
    this.monadM = monadM;
  }

  override public function flatMap<A,B>(val:ArrayT<M,A>, f: A->ArrayT<M,B>):ArrayT<M,B>
  {
    function f1 (a:Array<A>)
    {
      var res = [];
      function pushElems (x:Array<B>) for (e2 in x) res.push(e2);

      for (e1 in a)
      {
        monadM.map(f(e1).runT(), pushElems);
      }
      return monadM.pure(res);
    }

    return monadM.flatMap(val.runT(), f1).arrayT();
  }

  override public function pure<A>(x:A):ArrayT<M,A>
  {
    return monadM.pure([x]).arrayT();
  }

  override public function map<A,B>(v:ArrayT<M, A>,f:A->B):ArrayT<M, B>
  {
    var z = v.runT();
    return  monadM.map(z,Arrays.map.bind(_,f)).arrayT();
  }
}


