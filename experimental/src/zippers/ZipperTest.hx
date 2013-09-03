
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


enum Node<A> {
	DeadEnd(x:A);
	Passage(x:A, end:Node<A>);
	Fork(x:A, left:Node<A>, right:Node<A>);
}

enum Branch<A> {
	KeepStraightOn(a:A);
	TurnLeft(a:A, n:Node<A>);
	TurnRight(a:A, n:Node<A>);
}

typedef Thread<A> = LazyList<Branch<A>>;

typedef ZipperTC<E,A> = zippers.Zipper.Zipper<E,A>;

private typedef Zipper<A> = Tup2<Thread<A>, Node<A>>;





class ListZipperProps implements AutoEnumFields<ListZipper<Dynamic>> {

}

class ListZipperInstance<A> implements ZipperTC<ListZipper<A>, A>
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

	public static function back<A>(a:ListZipper<A>):Option<ListZipper<A>>
	{
		return switch a {
			case ListZipper(a, Cons(x, tail), right): Some(ListZipper(x, tail, ImLists.cons(right, a)));
			case _ : 				 				  None;
		}
	}

}

class Nodes {

	public static function zipperToString <A>(a:Zipper<A>):String {
		return "(" + a._1.toString() + ", " + Std.string(a._2) + ")";
	}

	public static function get <A>(a:Node<A>):A {
		return switch (a) {
			case DeadEnd(x): x;
			case Passage(x,_): x;
			case Fork(x,_,_): x;
		}
	}
	
	public static function put <A>(x:A, a:Node<A>):Node<A> 
	{
		return switch (a) {
			case DeadEnd(_): DeadEnd(x);
			case Passage(_,end): Passage(x,end);
			case Fork(_,left,right): Fork(x,left, right);
		}
	}

	public static function turnRight<A>(a:Zipper<A>):Option<Zipper<A>>
	{
		return switch [a._1, a._2] {
			case [t, Fork(x, l, r)]: Some(tup2(LazyLists.cons(t, TurnRight(x,l)), r));
			case _ : 			None;
		}
	}

	public static function keepStraightOn<A>(a:Zipper<A>):Option<Zipper<A>>
	{
		return switch [a._1, a._2] {
			case [t, Passage(x, n)]: Some(tup2(LazyLists.cons(t, KeepStraightOn(x)), n));
			case _ : 			None;
		}
	}

	public static function back<A>(a:Zipper<A>):Option<Zipper<A>>
	{
		return switch [a._1, a._2] {
			case [a, _] if (LazyLists.isEmpty(a)): None;
			case [a, n]: 
				var first = LazyLists.first(a);
				var tail = LazyLists.drop(a, 1);
				switch (first) 
				{
					case TurnRight(x, r): Some(tup2(tail, Fork(x, n, r)));
					case TurnLeft(x, l): Some(tup2(tail, Fork(x, l, n)));
					case KeepStraightOn(x): Some(tup2(tail, Passage(x, n)));
				}

		}
	}
}


class ZipperTest {

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

		// var value = 1;
		// var labyrinth = Passage(1,Passage(2, Passage(3, Fork(4, DeadEnd(5), DeadEnd(6)))));

		// var start = tup2(LazyLists.mkEmpty(), labyrinth);

		// var forward = Nodes.keepStraightOn(start);

		//trace(labyrinth);
//		//trace(forward);
//
		//trace(forward.flatMap(Nodes.keepStraightOn));

		// Ht.implicit(Monads.optionMonad);


		// var t = haxe.Timer.stamp();
		// var x = Do.run(
		// 	pos <= Some(start),
		// 	pos <= Nodes.keepStraightOn(pos),
		// 	pos <= Nodes.keepStraightOn(pos),
		// 	pos <= Nodes.keepStraightOn(pos),
		// 	pos <= Some(tup2(pos._1, Nodes.put(17, pos._2))),
		// 	pos <= Nodes.turnRight(pos),
		// 	pos <= Nodes.back(pos),
		// 	pos <= Nodes.back(pos),
		// 	pos <= Nodes.back(pos),
		// 	pos <= Nodes.back(pos),
		// 	pure(pos)
		// );
		//trace(haxe.Timer.stamp()-t);
		//trace(x.map(Nodes.zipperToString));
		//trace(start);
		
		// var emptyMap = RBMaps.empty();

		// trace(Std.string(emptyMap.insert._("Hello",1)));
		// var m2 = emptyMap.insert._("Hello",1).insert._("Whatever", 2);

		// trace(Std.string(m2));
		// trace(Std.string(m2.get._("Hello")));
		// trace(Std.string(m2.get._("Whatever")));

		// trace(Std.string(m2.remove._("Hello").get._("Hello")));

		// trace(Std.string(m2.remove._("Hello").insert._("Hey", 4)));

		

		// var loops = 1000000;
		// {
		// 	trace("LAZYLISTS");
		// 	var t = haxe.Timer.stamp();
		// 	var ll = LazyLists.mkEmpty();

		// 	for (i in 0...loops) {
				

		// 		ll = LazyLists.cons(ll, Some(i));

				
		// 	}
			
		// 	trace(haxe.Timer.stamp()-t);
		// 	var t = haxe.Timer.stamp();

		// 	ll = LazyLists.map(ll, function (x) return x.map(function (y) return y + 1));
		// 	trace(haxe.Timer.stamp()-t);

		// 	var t = haxe.Timer.stamp();
		// 	trace(Std.string(ll.first()));
		// 	trace(Std.string(ll.lastOption()));
		// 	trace(haxe.Timer.stamp()-t);
		// 	trace("-----------------");
		// }
		
		// {
		// 	trace("ARRAYS MUTABLE");
		// 	var t = haxe.Timer.stamp();
		// 	var ll = [];
			

		// 	for (i in 0...loops) {
		// 		ll.push(Some(i));
		// 	}
		// 	trace(haxe.Timer.stamp()-t);
		// 	var t = haxe.Timer.stamp();
		// 	ll = Arrays.map(ll, function (x) return x.map(function (y) return y + 1));
		// 	trace(haxe.Timer.stamp()-t);
			

		// 	var t = haxe.Timer.stamp();
		// 	trace(Std.string(Arrays.first(ll)));
		// 	trace(Std.string(Arrays.lastOption(ll)));
		// 	trace(haxe.Timer.stamp()-t);
		// 	trace("-----------------");
		// }

		// {
		// 	trace("LIST MUTABLE");
		// 	var t = haxe.Timer.stamp();
		// 	var ll = new List();

		// 	for (i in 0...loops) {
		// 		ll.push(Some(i));
		// 	}
		// 	trace(haxe.Timer.stamp()-t);
		// 	var t = haxe.Timer.stamp();
		// 	ll = ll.map(function (x) return x.map(function (y) return y + 1));
		// 	trace(haxe.Timer.stamp()-t);

		// 	var t = haxe.Timer.stamp();
		// 	trace(Std.string(ll.first()));
		// 	trace(Std.string(ll.last()));
		// 	trace(haxe.Timer.stamp()-t);
		// 	trace("-----------------");
		// }
		// {
		// 	trace("IMMUTABLE LISTS");
		// 	var t = haxe.Timer.stamp();
		// 	var ll = ImLists.mkEmpty();

		// 	for (i in 0...loops) {
		// 		ll = ImLists.cons(ll,Some(i));
		// 	}
		// 	trace(haxe.Timer.stamp()-t);
		// 	var t = haxe.Timer.stamp();
		// 	ll = ImLists.map(ll, function (x) return x.map(function (y) return y + 1));
		// 	trace(haxe.Timer.stamp()-t);



		// 	var t = haxe.Timer.stamp();
		// 	trace(Std.string(ImLists.first(ll)));
		// 	trace(Std.string(ImLists.lastOption(ll)));
		// 	trace(haxe.Timer.stamp()-t);
		// 	trace("-----------------");
		// }
		// trace("10.000.000 Option creations");
		// var t = haxe.Timer.stamp();
		// var x = Some(4);
		// for (i in 0...10000000) {
		// 	x = Some(i);
		// }
		// trace(haxe.Timer.stamp()-t);

		// trace("-----------------");

	}
	

}