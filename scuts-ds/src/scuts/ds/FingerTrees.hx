
package scuts.ds;

import scuts.core.Arrays;
import scuts.core.Options;
import scuts.core.Tuples;
import scuts.core.Tuples.*;
import scuts.core.Unit;
import scuts.ds.ImLists;

import scuts.ht.classes.Foldable;
import scuts.ht.instances.Foldables;
import scuts.ht.instances.std.ImListFoldable;
import scuts.ht.core.Of;
import scuts.ht.core.In;

using scuts.core.Functions;


using scuts.ds.LazyLists;

using scuts.ds.FingerTrees.FingerTrees;


@:publicFields private class Nodes 
{
	static function foldRight<A,B>(x:Node<A>, z:B, f:A->B->B):B return switch (x) 
	{
		case Node2(a,b): f(a, f(b,z));
		case Node3(a,b,c): f(a, f(b,f(c,z)));
	}

	static function foldLeft<A,B>(x:Node<A>, z:B, f:B->A->B):B return switch (x) 
	{
		case Node2(a,b): f(f(z,b),a);
		case Node3(a,b,c): f(f( f(z,a) ,b),c);
	}

	static function toDigit<A,B>(x:Node<A>):Digit<A> return switch (x) 
	{
		case Node2(a,b): Two(a,b);
		case Node3(a,b,c): Three(a,b,c);
	}

	static function toTree <A>(x:Node<A>):FingerTree<A> return switch (x) 
	{
		case Node2(a,b):   Deep(One(a), Empty, One(b));
		case Node3(a,b,c): Deep(One(a), Empty, Two(b,c));
	}
		
	static function map<A,B>(x:Node<A>, f:A->B):Node<B> return switch (x) 
	{
		case Node2(a,b): Node2(f(a),f(b));
		case Node3(a,b,c): Node3(f(a),f(b),f(c));
	}	
}

@:publicFields private class Digits 
{

	static function map<A,B>(x:Digit<A>, f:A->B):Digit<B> return switch (x) 
	{
		case One(a): 		One(f(a));
		case Two(a,b): 	    Two(f(a), f(b));
		case Three(a,b,c):  Three(f(a), f(b), f(c));
		case Four(a,b,c,d): Four(f(a), f(b), f(c), f(d));
	}


	static function toImList<A>(x:Digit<A>):ImList<A> return switch (x) 
	{
		case One(a): 		ImLists.mkOne(a);
		case Two(a,b): 	    ImLists.fromArray([a,b]);
		case Three(a,b,c):  ImLists.fromArray([a,b,c]);
		case Four(a,b,c,d): ImLists.fromArray([a,b,c,d]);
	}


	static function foldRight<A,B>(x:Digit<A>, z:B, f:A->B->B):B return switch (x) 
	{
		case One(a): 		f(a, z);
		case Two(a,b): 	    f(a, f(b, z));
		case Three(a,b,c):  f(a, f(b, f(c, z)));
		case Four(a,b,c,d): f(a, f(b, f(c, f(d,z))));
	}

	static function foldLeft<A,B>(x:Digit<A>, z:B, f:B->A->B):B return switch (x) 
	{
		case One(a): 		f( z, 		           a);
		case Two(a,b): 	    f( f(z,            a), b);
		case Three(a,b,c):  f( f(f(z,      a), b), c);
		case Four(a,b,c,d): f( f(f(f(z,a), b), c), d);
	}


	static function toTree <A>(x:Digit<A>):FingerTree<A> return switch (x) 
	{
		case One(a) :       Single(a); 
		case Two(a,b):      Deep(One(a), Empty, One(b));
		case Three(a,b,c):  Deep(One(a), Empty, Two(b,c));
		case Four(a,b,c,d): Deep(One(a), Empty, Three(b,c,d));
	}

	static function headLeft <A>(x:Digit<A>):A
	{
		return switch (x) {
			case One(a) | Two(a,_) | Three(a,_,_) | Four(a,_,_,_): a;
		}
	}

	static function tailLeft <A>(x:Digit<A>):Option<Digit<A>>
	{
		return switch (x) {
			case One(_):		 None;
			case Two(_,b):		 Some(One(b));
			case Three(_,b,c):	 Some(Two(b,c));
			case Four(_ ,b,c,d): Some(Three(b,c,d));
			
		}
	}

	static function headRight <A>(x:Digit<A>):A
	{
		return switch (x) {
			case One(a) | Two(_,a) | Three(_,_,a) | Four(_,_,_,a): a;
		}
	}

	static function tailRight <A>(x:Digit<A>):Option<Digit<A>> return switch (x) 
	{
		case One(_):    	 None;
		case Two(a,_):     	 Some(One(a));
		case Three(a,b,_):   Some(Two(a,b));
		case Four(a ,b,c,_): Some(Three(a,b,c));
	}
}

class FingerTrees {

	public static function fromFoldable <F,A>(x:Of<F,A>, fromLeft:Bool, foldable:Foldable<F>):FingerTree<A>
	{
		return 
			if (fromLeft) Tools.liftRight(x, Empty, foldable) else 
			Tools.liftRight(x, Empty, foldable);
		
	}

	public static inline function fromArray<A>(x:Array<A>):FingerTree<A> 
	{
		return Arrays.foldLeft(x, mkEmpty(), pushBack);
	}

	public static inline function toArray<A>(x:FingerTree<A>, fromLeft:Bool):Array<A> 
	{
		var a = [];
		each(x, fromLeft, a.push);
		return a;
	}

	public static inline function toArrayFromLeft<A>(x:FingerTree<A>):Array<A> return toArray(x, true);
	public static inline function toArrayFromRight<A>(x:FingerTree<A>):Array<A> return toArray(x, false);

	public static inline function each<A>(x:FingerTree<A>, fromLeft:Bool, f:A->Void):Void 
	{
		if (fromLeft)
			foldLeft(x, Unit, function (_,x) {
				f(x);
				return Unit;
			});	
		else
			foldRight(x, Unit, function (x,_) {
				f(x);
				return Unit;
			});		
	}


	public static inline function isEmpty<A>(x:FingerTree<A>):Bool return switch (x) 
	{
		case Empty : true;
		case _ : 	 false;
	}
	
	public static function toImListFromLeft <A>(x:FingerTree<A>) 
	{
		return foldLeft(x,scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons);
	}

	public static function toImListFromRight <A>(x:FingerTree<A>) 
	{
		return foldRight(x,scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons.flip());
	}

	public static inline function mkEmpty<A>():FingerTree<A>
	{
		return Empty;
	}

	public static function headLeft<A>(x:FingerTree<A>):Option<A>
	{
		return switch (x) 
		{
			case Empty : None;
			case Single(x): Some(x);
			case _ : switch (viewLeft(x)) 
			{
				case ViewNil : None;
				case ViewCons(a,_):Some(a);
			}
		}
		
	}
	public static function tailLeft<A>(x:FingerTree<A>):FingerTree<A>
	{
		return switch (x) 
		{
			case Empty : Empty;
			case Single(_) : Empty;
			case _ : switch (viewLeft(x)) 
			{
				case ViewNil : mkEmpty();
				case ViewCons(_,tail):tail;
			}
		}
		
	}

	public static function headRight<A>(x:FingerTree<A>):Option<A>
	{
		return switch (x) 
		{
			case Empty : None;
			case Single(x): Some(x);
			case _ : switch (viewRight(x)) 
			{
				case ViewNil : None;
				case ViewCons(a,_):Some(a);
			}
		}
	}

	public static function tailRight<A>(x:FingerTree<A>):FingerTree<A>
	{
		return switch (x) {
			case Empty : Empty;
			case Single(_) : Empty;
			case _ : switch (viewRight(x)) 
			{
				case ViewNil : mkEmpty();
				case ViewCons(_,tail):tail;
			}
		}
	}

	public static function deepLeft<A>(x:FingerTree<Node<A>>, tail:Option<Digit<A>>, sf:Digit<A>):FingerTree<A>
	{
		return switch [tail, x,sf] {
			case [None, m, sf]: switch (viewLeft(m)) 
			{
				case ViewCons(a, m1): Deep(Nodes.toDigit(a), m1, sf);
				case ViewNil: 		  Digits.toTree(sf);
			}
			case [Some(pr), m, sf]:   Deep(pr, m, sf);
		}
	}

	

	public static function deepRight<A>(x:FingerTree<Node<A>>, tail:Option<Digit<A>>, pr:Digit<A>):FingerTree<A> return switch [tail, x,pr] 
	{
		case [None, m, pr]: switch (viewRight(m)) 
		{
			case ViewCons(a, m1): Deep(pr, m1, Nodes.toDigit(a));
			case ViewNil: 		  Digits.toTree(pr);
		}
		case [Some(sf), m, pr]:   Deep(pr, m, sf);
	}

	public static function takeLeft<A>(x:FingerTree<A>, num:Int):FingerTree<A>
	{
		return if (num == 0) mkEmpty() else switch viewLeft(x) 
		{
			case ViewNil: Empty;
			case ViewCons(x,tail): takeLeft(tail, num-1).pushFront(x);
		}
	}

	public static function dropLeft<A>(x:FingerTree<A>, num:Int):FingerTree<A>
	{
		return if (num == 0) x else switch viewLeft(x) 
		{
			case ViewNil: Empty;
			case ViewCons(x,tail): dropLeft(tail, num-1);
		}
	}

	public static function dropRight<A>(x:FingerTree<A>, num:Int):FingerTree<A>
	{
		return if (num == 0) x else switch viewRight(x) 
		{
			case ViewNil: Empty;
			case ViewCons(x,tail): dropRight(tail, num-1);
		}
	}

	public static function takeRight<A>(x:FingerTree<A>, num:Int):FingerTree<A>
	{
		return if (num == 0) mkEmpty() else switch viewRight(x)
		{
			case ViewNil: Empty;
			case ViewCons(x,tail): takeRight(tail, num-1).pushBack(x);
		}
	}

	public static function partitionBy<A>(x:FingerTree<A>, f:A->Bool):Tup2<FingerTree<A>, FingerTree<A>>
	{

		function fold1 (acc:Tup2<FingerTree<A>, FingerTree<A>>, e:A) {
			return if (f(e)) {
				tup2(acc._1.pushBack(e), acc._2);
			} else {
				tup2(acc._1, acc._2.pushBack(e));
			}
		}

		return foldLeft(x, tup2(mkEmpty(), mkEmpty()), fold1);
	}



	public static function viewLeft<A>(x:FingerTree<A>):View<A, FingerTree<A>> return switch (x) 
	{
		case Empty: ViewNil;
		case Single(x): 			   ViewCons(x, Empty);
		case Deep(pr, m, sf): ViewCons(Digits.headLeft(pr), deepLeft(m, Digits.tailLeft(pr), sf));	
	}


	public static function viewRight<A>(x:FingerTree<A>):View<A, FingerTree<A>> return switch (x) 
	{
		case Empty: ViewNil;
		case Single(x): 			   ViewCons(x, Empty);
		case Deep(pr, m, sf): ViewCons(Digits.headRight(sf), deepRight(m, Digits.tailRight(sf), pr));	
	}

	public static function foldRight<A,B>(x:FingerTree<A>, z:B, f:A->B->B):B 
	{
		function reduceDeep(pr, m, sf) 
		{
			var r1 = Digits.foldRight.bind(_,_,f);
			var r2 = FingerTrees.foldRight.bind(_,_,Nodes.foldRight.bind(_,_,f));

			return r1(pr, r2(m, r1(sf, z)));
		}

		return switch (x) 
		{
			case Empty: 				   z;
			case Single(a): 			   f(a,z);
			case Deep(pr, m, sf): reduceDeep(pr, m, sf);
		}
	}

	public static function concat<A>(f1:FingerTree<A>, f2:FingerTree<A>):FingerTree<A>
	{
		return app3(f1, ImLists.mkEmpty(), f2);
	}

	public static function app3<A>(f1:FingerTree<A>, l:ImList<A>, f2:FingerTree<A>):FingerTree<A>
	{
		return switch [f1, l, f2] 
		{
			case [Empty, ts, xs]: Tools.liftRight(ts, xs, Foldables.imListFoldable);
			case [xs, ts, Empty]: Tools.liftLeft(ts, xs, Foldables.imListFoldable);
			case [Single(x), ts, xs]: pushFront(Tools.liftRight(ts, xs,  Foldables.imListFoldable), x);
			case [xs, ts, Single(x)]: pushBack (Tools.liftLeft(ts, xs, Foldables.imListFoldable), x);
			case [Deep(pr1, m1, sf1), ts, Deep(pr2, m2, sf2)]: 
				var l1 = Digits.toImList(sf1);
				var l2 = Digits.toImList(pr2);
				var l = ImLists.concat(ImLists.concat(l1, ts), l2);
				var middle = app3(m1, nodes(l), m2);
				Deep(pr1, middle, sf2);
		}
		
	}

	static function nodes <A>(x:ImList<A>):ImList<Node<A>>
	{
		return switch (x) {
			case Cons(a, Cons(b, Nil)): ImLists.fromArray([Node2(a,b)]);
			case Cons(a, Cons(b, Cons(c, Nil))): ImLists.fromArray([Node3(a,b,c)]);
			case Cons(a, Cons(b, Cons(c, Cons(d, Nil)))): ImLists.fromArray([Node2(a,b), Node2(c,d)]);
			case Cons(a, Cons(b, Cons(c, tail))): ImLists.cons(nodes(tail), Node3(a,b,c));
			case _ : throw "unexpected";
		}
	}

	public static function foldLeft<A,B>(x:FingerTree<A>, z:B, f:B->A->B):B 
	{
		inline function reduceDeep(pr, m, sf) 
		{
			var r1 = Digits.foldLeft.bind(_,_,f).flip();
				
			var r3 = Nodes.foldLeft.bind(_,_,f).flip();
			var r2 = FingerTrees.foldLeft.bind(_,_,r3).flip();
			return r1(r2(r1(z, pr),m),sf);
		}
		return switch (x) 
		{
			case Empty:  		  z;
			case Single(a): 	  f(z,a);
			case Deep(pr, m, sf): reduceDeep(pr, m, sf);
				
		}
	}

	public static function first <A>(x:FingerTree<A>):Option<A>
	{
		return switch (x) {
			case Empty:None;
			case Single(a)
			   | Deep(One(a) 
			   | Two(a,_) 
			   | Three(a,_,_) 
			   | Four(a,_,_,_),_,_):Some(a);
		}
	}

	public static function last <A>(x:FingerTree<A>):Option<A>
	{
		return switch (x) 
		{
			case Empty:None;
			case Single(a) 
			   | Deep(_,_, One(a) 
			   			 | Two(_,a) 
			   			 | Three(_,_,a) 
			   			 | Four(_,_,_,a)): Some(a);
			
		}
	}

	

	public static function map <A,B>(x:FingerTree<A>, f:A->B):FingerTree<B>
	{

		function deepMap(sf, m, pf) 
		{
			var f1 = function (x1) return Nodes.map(x1,f);

			var sfMap = Digits.map(sf, f);
			var mMap = map(m, f1);
			var pfMap = Digits.map(pf, f);
			
			return Deep(sfMap, mMap, pfMap);
		}

		return switch (x) 
		{
			case Empty:mkEmpty();
			case Single(a): Single(f(a));
			
			case Deep(sf,m,pf): deepMap(sf, m, pf);
			
		}
	}

	public static function pushFront <A>(x:FingerTree<A>, a:A):FingerTree<A>
	{
		return switch (x) 
		{
			case Empty: 					 		  Single(a);
			case Single(b): 				 		  Deep(One(a), mkEmpty(), One(b));
			case Deep(Four(b,c,d,e), m, sf): 		  Deep(Two(a,b), pushFront(m, Node3(c,d,e)), sf);
			case Deep(One(b), m, sf): 		          Deep(Two(a,b), m, sf);
			case Deep(Two(b,c), m, sf):               Deep(Three(a,b,c), m, sf);
			case Deep(Three(b,c,d), m, sf):           Deep(Four(a,b,c,d), m, sf);
		}
	}

	
	public static function pushBack <A>(x:FingerTree<A>, z:A):FingerTree<A>
	{
		return switch (x) 
		{
			case Empty: 					 			Single(z);
			case Single(a): 				 			Deep(One(a), mkEmpty(), One(z));
			case Deep(pf, m, Four(b,c,d,e)): 			Deep(pf, pushBack(m, Node3(b, c, d)), Two(e,z));
			case Deep(pf, m, One(b)): 		 			Deep(pf, m, Two(b,z));
			case Deep(pf, m, Two(b,c)):      			Deep(pf, m, Three(b,c,z));
			case Deep(pf, m, Three(b,c,d)):  			Deep(pf, m, Four(b,c,d,z));
		}
	}
	

}

private enum Node<A> {
	Node2(a1:A, a2:A);
	Node3(a1:A, a2:A, a3:A);
}

enum FingerTree<A> {
	Empty;
	Single(a:A);
	Deep(l:Digit<A>, f:FingerTree<Node<A>>, r:Digit<A>);
}


private enum Digit<A> {
	One(a:A);
	Two(a1:A, a2:A);
	Three(a1:A, a2:A, a3:A);
	Four(a1:A, a2:A, a3:A, a4:A);
}


private enum View<A,S> {
	ViewNil;
	ViewCons(a:A, x:S);

}



private class Tools {

	


	public static function toList <F,A>(x:Of<F,A>, foldable:Foldable<F>):LazyList<A>
	{
		return foldable.foldRight(x,LazyLists.mkEmpty(),LazyLists.cons.flip());
	}

	
	public static function liftLeft <F,A>(x:Of<F,A>, ft:FingerTree<A>, foldable:Foldable<F>):FingerTree<A>
	{
		return foldable.foldLeft(x,ft,FingerTrees.pushBack);
	}

	public static function liftRight <F,A>(x:Of<F,A>, ft:FingerTree<A>, foldable:Foldable<F>):FingerTree<A>
	{
		return foldable.foldRight(x,ft,FingerTrees.pushFront.flip());
		
	}

	public static function toTree <F,A>(x:Of<F,A>, fromLeft:Bool, foldable:Foldable<F>):FingerTree<A>
	{
		return 
			if (fromLeft) liftRight(x, Empty, foldable) else 
			liftRight(x, Empty, foldable);
		
	}
}