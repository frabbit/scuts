
package zippers;

using scuts.core.Functions;
using scuts.ht.Context;

import scuts.core.Arrays;

import scuts.core.Tuples;
using scuts.ds.LazyLists;
import scuts.ds.ImLists;
using scuts.ds.RedBlackTree;
import scuts.ht.core.Ht;
import scuts.ht.instances.Monads;
import scuts.ht.syntax.Do;
import scuts.macros.AutoEnumFields;
import scuts.core.Tuples.*;



using scuts.core.Options;


enum ListZipper<A> {
	ListZipper(focus:A, left:ImList<A>, right:ImList<A>);
}





class ListZipperProps implements AutoEnumFields<ListZipper<Dynamic>> {

}

class ListZipperInstance<A> implements Zipper<ListZipper<A>, A>
{
	public function new () {}

	public function get (a:ListZipper<A>):A {
		return ListZippers.get(a);
	}
	public function put (a:ListZipper<A>, x:A):ListZipper<A> {
		return ListZippers.put(a, x);
	}
	public function forward (a:ListZipper<A>):Option<ListZipper<A>> {
		return ListZippers.forward(a);
	}
	public function back (a:ListZipper<A>):Option<ListZipper<A>> {
		return ListZippers.back(a);
	}

	public function modify (a:ListZipper<A>, f:A->A):ListZipper<A> {
		return ListZippers.modify(a, f);
	}

	public function findNext (e:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
		return ListZippers.findNext(e, f);
	}

	public function findPrevious (e:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
		return ListZippers.findPrevious(e, f);
	}

	public function toImList (x:ListZipper<A>):ImList<A> 
	{
		return ListZippers.toImList(x);
	}
}


class ListZippers {

	public static function toImList <A>(x:ListZipper<A>):ImList<A> {
		return switch (x) {
			case ListZipper(v, l, r): ImLists.concatReversed(l, ImLists.cons(r,v));
		}
	}

	public static function findNext <A>(x:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
		return switch (x) {
			case ListZipper(a, _, _) if (f(a)): Some(x); 
			case ListZipper(_, _, Nil): None;
			case ListZipper(a, l, Cons(a1, tail)): findNext(ListZipper(a1, ImLists.cons(l, a), tail), f); 
				
		}
	}

	public static function findPrevious <A>(x:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
		return switch (x) {
			case ListZipper(_, Nil, _): None;
			case ListZipper(a, _, _) if (f(a)): Some(x); 
			case ListZipper(a, Cons(a1, tail), r): findNext(ListZipper(a1, tail, ImLists.cons(r, a)), f); 
				
		}
	}


	public static function fromImList <A>(a:ImList<A>):Option<ListZipper<A>>
	{
		return switch (a) {
			case Cons(a, tail): Some(fromTailAndFocus(tail, a));
			case Nil: None;
		}
	}

	public static inline function fromTailAndFocus <A>(tail:ImList<A>, focus:A):ListZipper<A>
	{
		return ListZipper(focus, ImLists.mkEmpty(), tail);
		
	}

	public static function zipperToString <A>(a:ListZipper<A>):String 
	{
		return "( focus: " + ListZipperProps.focus(a) + ", left: " + ListZipperProps.left(a) + ", right: " + ListZipperProps.right(a) + ")";
	}

	public static function get <A>(a:ListZipper<A>):A {
		return ListZipperProps.focus(a);
	}
	
	public static function put <A>(a:ListZipper<A>, x:A):ListZipper<A> 
	{
		return switch (a) {
			case ListZipper(_, left, right): ListZipper(x, left, right);
		}
	}

	public static function modify <A>(a:ListZipper<A>, f:A->A):ListZipper<A> 
	{
		return put(a, f(get(a)));
	}

	
	public static function forward<A>(a:ListZipper<A>):Option<ListZipper<A>>
	{
		return switch a {
			case ListZipper(a, left, Cons(x, tail)): Some(ListZipper(x, ImLists.cons(left, a), tail));
			case _ : 				 				 None;
		}
	}

	
	
	public static function map<A,B>(a:ListZipper<A>, f : A->B):ListZipper<B>
	{
		return switch (a) {
			case ListZipper(x, left, right): ListZipper(f(x), ImLists.map(left, f), ImLists.map(right, f));
		}
	}

	public static function back<A>(a:ListZipper<A>):Option<ListZipper<A>>
	{
		return switch a {
			case ListZipper(a, Cons(x, tail), right): Some(ListZipper(x, tail, ImLists.cons(right, a)));
			case _ : 				 				  None;
		}
	}

}


class ListZipperTest {

	public static function main () {

		var z = new ListZipperInstance();




		var list = Cons(1, Cons(2, Cons(3, Nil)));

		var listStart = ListZippers.fromTailAndFocus(list, 0);

		var forward = ListZippers.forward(listStart);



		trace(Std.string(forward.map(ListZippers.toImList.next(ImLists.toString.bind(_, Std.string)))));

		trace(Std.string(ListZippers.findNext(listStart, function (x) return x == 3).map(ListZippers.zipperToString)));		

		trace(Std.string(z.forward(listStart).map(ListZippers.zipperToString)));

		trace(Std.string(forward.map(ListZippers.zipperToString)));

		var forward2 = forward.flatMap(ListZippers.forward);

		trace(Std.string(forward2.map(ListZippers.zipperToString)));

		var forward3 = forward2.flatMap(ListZippers.forward);

		trace(Std.string(forward3.map(ListZippers.zipperToString)));

		var forward4 = forward3.flatMap(ListZippers.forward);

		trace(Std.string(forward4.map(ListZippers.zipperToString)));

		var back1 = forward3.flatMap(ListZippers.back);

		trace(Std.string(back1.map(ListZippers.zipperToString)));

	}
	

}