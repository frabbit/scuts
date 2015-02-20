package scuts.ht.instances.std;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;

using scuts.ht.instances.std.ArrayT;

import scuts.core.Arrays;




class ArrayTBind<M> implements Bind<ArrayT<M,In>>
{

  var monadM:Monad<M>;

  public function new (monadM:Monad<M>)
  {
    this.monadM = monadM;
  }

  public function flatMap<A,B>(val:ArrayT<M,A>, f: A->ArrayT<M,B>):ArrayT<M,B>
  {
    function f1 (a:Array<A>):M<Array<B>>
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
}
