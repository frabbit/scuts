package scuts.ht.builder;


import scuts.ht.classes.Functor;
import scuts.ht.classes.MonadEmpty;

import scuts.ht.core.Of;
import scuts.core.Arrays;
import scuts.ht.classes.Monad;

import scuts.ht.classes.Applicative;
import scuts.ht.classes.Bind;
import scuts.ht.core.Of;

import scuts.Scuts;

class FunctorBuilder
{


  public static function createFromMap <M,A,B>(map:Of<M,A>->(A->B)->Of<M,B>):Functor<M>
  {
    var f = new FunctorFromMap();
    f.mapDyn = map;
    return f;
  }
}





/**
 * Either flatMap or flatten must be overriden by classes extending MonadAbstract
 */
private class FunctorFromMap<M> implements Functor<M>
{
  public function new () {}

  public dynamic function mapDyn<A,B>(x:Of<M,A>, f:A->B):Of<M,B> return null;

  public function map<A,B>(x:Of<M,A>, f:A->B):Of<M,B> return mapDyn(x, f);

}

