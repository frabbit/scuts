
package iteratee;

import scuts.core.Options;
import scuts.core.Unit;
import scuts.ht.classes.Applicative;
import scuts.ht.classes.Apply;
import scuts.ht.classes.Bind;
import scuts.ht.classes.Functor;
import scuts.ht.classes.Monad;
import scuts.ht.classes.Pure;
import scuts.ht.core.Of;
import scuts.ht.core.In;



using scuts.core.Functions;
using scuts.ds.LazyLists;

enum Input<E> {
 	Elem(e:E);
 	Empty;
 	Eof;
}

enum IterV<E,A> {
 	Done(a:A, e:Input<E>);
 	Cont(k:Input<E>->IterV<E,A>);
}


class IterVFunctor<E> implements Functor<IterV<E,In>>
{
	public function new () {}
	public function map <A,B>(it:IterV<E,A>, f:A->B):IterV<E,B>
	{
		return Iteratees.map(it, f);
	}
}

class IterVBind<E> implements scuts.ht.classes.Bind<IterV<E,In>>
{
	public function new () {}
	public function flatMap <A,B>(it:IterV<E,A>, f:A->IterV<E,B>):IterV<E,B>
	{
		return Iteratees.flatMap(it, f);
	}
}

class IterVPure<E> implements Pure<IterV<E,In>>
{
	public function new () {}

	public function pure <A>(x:A):IterV<E,A>
	{
		return Iteratees.pure(x);
	}
}

class IterVApply<E> extends scuts.ht.classes.ApplyAbstract<IterV<E,In>>
{
	override public function apply<A,B>(val:IterV<E,A>, f1:IterV<E,A->B>):IterV<E,B>
	{
  		return Iteratees.apply(val, f1);
  	}
}

class IterVInstances
{

	@:implicit @:noUsing public static function iterVPure<E>():Pure<IterV<E,In>> {
		return new IterVPure();
	}
	@:implicit @:noUsing public static function iterVFunctor<E>():Functor<IterV<E,In>> {
		return new IterVFunctor();
	}
	@:implicit @:noUsing public static function iterVApply<E>():Apply<IterV<E,In>> {
		return new IterVApply(iterVFunctor());
	}
	@:implicit @:noUsing public static function iterVBind<E>():Bind<IterV<E,In>> {
		return new IterVBind();
	}
	@:implicit @:noUsing public static function iterVApplicative<E>():Applicative<IterV<E,In>> {
		return scuts.ht.syntax.ApplicativeBuilder.create(iterVPure(), iterVApply(),iterVFunctor());
	}
	@:implicit @:noUsing public static function iterVMonad<E>():Monad<IterV<E,In>> {
		return scuts.ht.syntax.MonadBuilder.createFromApplicativeAndBind(iterVApplicative(), iterVBind());
	}
}


class Iteratees {

	public static function run <E,A>(iter:IterV<E,A>):Option<A>
	{
		return switch (iter) {
			case Done(a,_): Some(a);
			case Cont(k):
				function run1 (iter) return switch (iter)
				{
					case Done(x,_): Some(x);
					case _ : None;
				}
				run1(k(Eof));
		}
	}

	public static function enumerate <E,A>(iter:IterV<E,A>,  l:LazyList<E>):IterV<E,A>
	{
		return switch [iter, l.get()] {
			case [i, LazyNil]: i;
			case [Done(_,_), _]: iter;
			case [Cont(k), LazyCons(x, xs)]: enumerate(k(Elem(x)), xs);
		}
	}

	public static function head <E,A>():IterV<E,Option<E>> {

		function step (e:Input<E>) return switch (e) {
			case Elem(e1): Done(Some(e1), Empty);
			case Empty: Cont(step);
			case Eof: Done(None, Eof);
		}

		return Cont(step);
	}
	public static function peek <E,A>():IterV<E,Option<E>> {

		function step (e:Input<E>) return switch (e) {
			case Elem(e1): Done(Some(e1), e);
			case Empty: Cont(step);
			case Eof: Done(None, Eof);
		}

		return Cont(step);
	}

	public static function drop <E,A>(num:Int):IterV<E,Unit>
	{
		return switch num {
			case 0: Done(Unit, Empty);
			case n:
				function step (e:Input<E>) return switch (e) {
					case Elem(_): drop(n-1);
					case Empty: Cont(step);
					case Eof: Done(Unit, Eof);
				}
				Cont(step);
		}

	}

	public static function length <E,A>():IterV<E,Int> {

		function step (acc:Int, e:Input<E>) return switch e {
			case Elem(_):  	Cont( step.bind(acc+1));
			case Empty: 	Cont(step.bind(acc));
			case Eof: 		Done(acc, Eof);
		}

		return Cont(step.bind(0));
	}

	public static function pure <E,A>(x:A):IterV<E,A> {
		return Done(x, Empty);
	}

	public static function map <E,A,B>(iter:IterV<E,A>, f:A->B):IterV<E,B> {
		return switch (iter)
		{
			case Done(x, str): Done(f(x), str);
			case Cont(k): Cont(map.bind(_,f).compose(k));
		}
	}

	public static function flatMap <E,A,B>(iter:IterV<E,A>, f:A->IterV<E,B>):IterV<E,B> {
		return switch (iter)
		{
			case Done(x, str): switch (f(x)) {
				case Done(x1, _): Done(x1, str);
				case Cont(k): k(str);
			}
			case Cont(k): Cont(function (str) return flatMap(k(str), f));
		}
	}

	public static function apply<E,A,B>(val:IterV<E,A>, f1:IterV<E,A->B>):IterV<E,B> {
  		return switch (f1) {
  			case Done(f, str): Iteratees.map(val, f);
  			case Cont(k): Cont(function (str) return apply(val, k(str)));
  		}
  	}


}

