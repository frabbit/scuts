package scuts.ht.instances.std;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Monad;
import scuts.ht.instances.std.ArrayTOf;

import scuts.ht.core.In;
import scuts.ht.core.Of;
import scuts.core.Arrays;




class ArrayTBind<M> implements Bind<Of<M,Array<In>>> 
{
  
  var monadM:Monad<M>;

  public function new (monadM:Monad<M>) 
  {
    this.monadM = monadM;
  }
  
  public function flatMap<A,B>(val:ArrayTOf<M,A>, f: A->ArrayTOf<M,B>):ArrayTOf<M,B> 
  {
    function f1 (a:Array<A>):Of<M, Array<B>>
    {
      var res = [];
      function pushElems (x:Array<B>) for (e2 in x) res.push(e2);
      
      for (e1 in a) 
      {
        monadM.map(f(e1), pushElems);
      }
      return monadM.pure(res);
    }
    
    return monadM.flatMap(val, f1);
  }
}
