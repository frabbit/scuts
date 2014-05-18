
package scuts.ht.instances;

using scuts.core.Lists;

import scuts.ht.classes.Functor;
import scuts.ht.classes.Monad;
import scuts.ht.classes.Show;

class ListInstances
{
	@:implicit @:noUsing public static var monad : Monad<List<In>> = new ListMonad();
  @:implicit @:noUsing public static var functor : Functor<List<In>> = monad;
  @:implicit @:noUsing public static function show<T>(showT:Show<T>) : Show<List<T>> return new ListShow(showT);
}

class ListShow<T> implements Show<List<T>>
{

  private var showT:Show<T>;

  public function new (showT:Show<T>)
  {
    this.showT = showT;
  }

  public function show (v:List<T>):String
  {
    return "List(" + v.map(function (x) return showT.show(x)).join(", ") + ")";
  }
}


class ListMonad implements Monad<List<In>>
{

  public function new () {}

  public function flatMap<B,C>(x:List<B>, f:B->List<C>):List<C>
  {
    return flatten(map(x,f));
  }

  public function pure <T>(x:T) {
  	var l = new List();
  	l.add(x);
  	return l;
  }

  public function flatten<B>(x:List<List<B>>):List<B>
  {
  	var r = new List();
  	for (e in x) for (e1 in e) r.add(e1);
    return r;
  }

  public function map<B,C>(x:List<B>, f:B->C):List<C>
  {
    return Lists.map(x, f);
  }
}