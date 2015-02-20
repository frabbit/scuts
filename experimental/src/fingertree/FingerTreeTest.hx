
package fingertree;

import scuts.core.Arrays;
import scuts.core.Options;
import scuts.ds.ImLists;
import scuts.ds.LazyLists;
import scuts.ht.core.Of;
import scuts.ht.core.In;

using scuts.core.Functions;

using scuts.ht.Context;


using scuts.ds.LazyLists;
using fingertree.FingerTreeTest.LazyListReduce;
using fingertree.FingerTreeTest.ArrayReduce;

using fingertree.FingerTreeTest.FingerTrees;


interface Size<F> {
	function size<X>(x:F<X>):Int;
}

interface DsCollection <F> {
	function isEmpty <X>():F<X>;
	function mkEmpty <X>():F<X>;
	function any<X>(x:F<X>, f:X->Bool):Bool;
	function exists<X>(x:F<X>, eq:Eq<X>):Bool;

}

interface DsList<F>
{
	function empty <X>():F<X>;
	function cons <X> (x:F<X>, e:X):F<X>;
	function tail <X> (x:F<X>, e:X):F<X>;
}

interface DsDeque<F>
{
	function removeRight <X> (x:F<X>, e:X):F<X>;
	function removeLeft <X> (x:F<X>, e:X):F<X>;
	function pushLeft <X> (x:F<X>, e:X):F<X>;
	function pushRight <X> (x:F<X>, e:X):F<X>;

	function tailLeft <X> (x:F<X>, e:X):F<X>;
	function tailRight <X> (x:F<X>, e:X):F<X>;

	function left <X> (x:F<X>, e:X):X;
	function right <X> (x:F<X>, e:X):X;
}



interface DsVector<F>
{

	function at <X>(x:F<X>, index:Int):X;
	function set <X>(x:F<X>, index:Int, val:X):F<X>;
}

@:publicFields class ArrayInstances implements DsVector<Array<In>> implements Size<Array<In>>
{
	inline function at <X>(x:Of<Array<In>, X>, index:Int):X {
		return (x:Array<X>)[index];
	}

	function set <X>(x:Of<Array<In>, X>, index:Int, val:X):Of<Array<In>, X>
	{
		var r = (x:Array<X>).copy();
		r[index] = val;
		return r;
	}


	private static inline function asArray <X>(x:Of<Array<In>,X>):Array<X> {
		return x;
	}

	inline function size<X>(x:Of<Array<In>, X>):Int
	{
		return asArray(x).length;
	}

	private function new () {}

	private static var instance:ArrayInstances = new ArrayInstances();

	// make them implicit
	@:implicit static inline function arraySize ():Size<Array<In>> return instance;
	@:implicit static inline function arraySizeInline ():ArrayInstances return instance;
	@:implicit static inline function arrayDsVector ():DsVector<Array<In>> return instance;

}

interface DsMap<F, K>
{
	function get <V>(x:F<K>, key:K):Option<V>;
	function exists <V>(x:F<K>, key:K):Bool;
	function put <V>(x:F<K>, key:K, val:V):F<K>;
	function remove <V>(x:F<K>, key:K):F<K>;
}


interface Reduce<F>
{
	function reduceRight<A,B>(x:F<A>, b:B, f:A->B->B):B;
	function reduceLeft<A,B>(x:F<A>, b:B, f:B->A->B):B;
}


@:publicFields class Nodes
{
	static function reduceRight<A,B>(x:Node<A>, z:B, f:A->B->B):B
	{
		return switch (x) {
			case Node2(a,b): f(a, f(b,z));
			case Node3(a,b,c): f(a, f(b,f(c,z)));
		}
	}

	static function reduceLeft<A,B>(x:Node<A>, z:B, f:B->A->B):B
	{
		return switch (x) {
			case Node2(a,b): f(f(z,b),a);
			case Node3(a,b,c): f(f( f(z,a) ,b),c);
		}
	}

	static function toDigit<A,B>(x:Node<A>):Digit<A>
	{
		return switch (x) {
			case Node2(a,b): Two(a,b);
			case Node3(a,b,c): Three(a,b,c);
		}
	}

	static function toTree <A>(x:Node<A>):FingerTree<A>
	{
		return reduceRight(x,Empty,FingerTrees.pushFront.flip());
	}

	static function map<A,B>(x:Node<A>, f:A->B):Node<B> {
		return switch (x) {
			case Node2(a,b): Node2(f(a),f(b));
			case Node3(a,b,c): Node3(f(a),f(b),f(c));
		}
	}
}

@:publicFields class Digits
{

	static function map<A,B>(x:Digit<A>, f:A->B):Digit<B>
	{
		return switch (x)
		{
			case One(a): 		One(f(a));
			case Two(a,b): 	    Two(f(a), f(b));
			case Three(a,b,c):  Three(f(a), f(b), f(c));
			case Four(a,b,c,d): Four(f(a), f(b), f(c), f(d));
		}
	}


	static function toImList<A>(x:Digit<A>):ImList<A>
	{
		return switch (x) {
			case One(a): 		ImLists.mkOne(a);
			case Two(a,b): 	    ImLists.fromArray([a,b]);
			case Three(a,b,c):  ImLists.fromArray([a,b,c]);
			case Four(a,b,c,d):
				trace(ImLists.fromArray([a,b,c,d]));
				ImLists.fromArray([a,b,c,d]);
		}
	}

	static function reduceRight<A,B>(x:Digit<A>, z:B, f:A->B->B):B
	{
		return switch (x) {
			case One(a): 		f(a, z);
			case Two(a,b): 	    f(a, f(b, z));
			case Three(a,b,c):  f(a, f(b, f(c, z)));
			case Four(a,b,c,d): f(a, f(b, f(c, f(d,z))));
		}
	}

	static function reduceLeft<A,B>(x:Digit<A>, z:B, f:B->A->B):B
	{
		return switch (x) {
			case One(a): 		f( z, 		           a);
			case Two(a,b): 	    f( f(z,            a), b);
			case Three(a,b,c):  f( f(f(z,      a), b), c);
			case Four(a,b,c,d): f( f(f(f(z,a), b), c), d);
		}
	}

	static function toTree <A>(x:Digit<A>):FingerTree<A>
	{
		return switch (x) {
			case One(a) : Single(a);
			case Two(a,b): Deep(One(a), Regular(Empty), One(b));
			case Three(a,b,c): Deep(Two(a,b), Regular(Empty), One(c));
			case Four(a,b,c,d): Deep(Three(a,b,c), Regular(Empty), One(c));
		}
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
			case One(_):None;
			case Two(_,b):Some(One(b));
			case Three(_,b,c):Some(Two(b,c));
			case Four(_ ,b,c,d):Some(Three(b,c,d));

		}
	}

	static function headRight <A>(x:Digit<A>):A
	{
		return switch (x) {
			case One(a) | Two(_,a) | Three(_,_,a) | Four(_,_,_,a): a;
		}
	}

	static function tailRight <A>(x:Digit<A>):Option<Digit<A>>
	{
		return switch (x) {
			case One(_):None;
			case Two(a,_):Some(One(a));
			case Three(a,b,_):Some(Two(a,b));
			case Four(a ,b,c,_):Some(Three(a,b,c));

		}
	}
}




class FingerTrees {

	static function pushFrontHelper1 <A>(a,b,c,d,e,m,sf)
	{
		function f() {
			var x = m();
			return pushFront(x, Node3(c,d,e));
		}
		return Deep(Two(a,b), Lazy(Tools.memo(f)), sf);
	}

	public static inline function isEmpty<A>(x:FingerTree<A>):Bool return switch (x)
	{
		case Empty : true;
		case _ : 	 false;
	}

	public static function toImListFromLeft <A>(x:FingerTree<A>)
	{
		return reduceLeft(x,scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons);
	}

	public static function toImListFromRight <A>(x:FingerTree<A>)
	{
		return reduceRight(x,scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons.flip());
	}

	public static inline function mkEmpty<A>():FingerTree<A>
	{
		return Empty;
	}

	public static function headLeft<A>(x:FingerTree<A>):Option<A>
	{
		return switch (viewLeft(x)) {
			case ViewNil : None;
			case ViewCons(a,_):Some(a);
		}
	}
	public static function tailLeft<A>(x:FingerTree<A>):FingerTree<A>
	{
		return switch (viewLeft(x)) {
			case ViewNil : mkEmpty();
			case ViewCons(_,tail):tail();
		}
	}

	public static function headRight<A>(x:FingerTree<A>):Option<A>
	{
		return switch (viewRight(x)) {
			case ViewNil : None;
			case ViewCons(a,_):Some(a);
		}
	}
	public static function tailRight<A>(x:FingerTree<A>):FingerTree<A>
	{
		return switch (viewRight(x)) {
			case ViewNil : mkEmpty();
			case ViewCons(_,tail):tail();
		}
	}

	public static function deepLeft<A>(x:FingerTree<Node<A>>, tail:Option<Digit<A>>, sf:Digit<A>):FingerTree<A>
	{
		return switch [tail, x,sf] {
			case [None, m, sf]: switch (viewLeft(m))
			{
				case ViewCons(a, m1): Deep(Nodes.toDigit(a), Lazy(m1), sf);
				case ViewNil: 		   Digits.toTree(sf);
			}
			case [Some(pr), m, sf]: Deep(pr, Regular(m), sf);
		}
	}



	public static function deepRight<A>(x:FingerTree<Node<A>>, tail:Option<Digit<A>>, pr:Digit<A>):FingerTree<A>
	{
		return switch [tail, x,pr]
		{
			case [None, m, pr]: switch (viewRight(m))
			{
				case ViewCons(a, m1): Deep(pr, Lazy(m1), Nodes.toDigit(a));
				case ViewNil: 		   Digits.toTree(pr);
			}
			case [Some(sf), m, pr]: Deep(pr, Regular(m), sf);
		}
	}

	static function viewLeftHelper1 (m, pr, sf)
	{
		return Tools.memo(function () return deepLeft(m, Digits.tailLeft(pr), sf));
	}

	static function viewLeftHelper2 (m, pr, sf)
	{
		return Tools.memo(function () return deepLeft(m(), Digits.tailLeft(pr), sf));
	}

	public static function viewLeft<A>(x:FingerTree<A>):View<A, FingerTree<A>>
	{
		return switch (x) {
			case Empty: ViewNil;
			case Single(x): 			   ViewCons(x, function () return Empty);
			case Deep(pr, Regular(m), sf): ViewCons(Digits.headLeft(pr), viewLeftHelper1(m,pr, sf));
			case Deep(pr, Lazy(m), sf):    ViewCons(Digits.headLeft(pr), viewLeftHelper2(m, pr, sf));
		}
	}

	static function viewRightHelper1 (m, pr, sf)
	{
		return Tools.memo(function () return deepRight(m, Digits.tailRight(sf), pr));
	}

	static function viewRightHelper2 (m, pr, sf)
	{
		return Tools.memo(function () return deepRight(m(), Digits.tailRight(sf), pr));
	}

	public static function viewRight<A>(x:FingerTree<A>):View<A, FingerTree<A>>
	{

		return switch (x) {
			case Empty: ViewNil;
			case Single(x): 			   ViewCons(x, function () return Empty);
			case Deep(pr, Regular(m), sf): ViewCons(Digits.headRight(sf), viewRightHelper1(m,pr,sf));
			case Deep(pr, Lazy(m), sf):    ViewCons(Digits.headRight(sf), viewRightHelper2(m,pr,sf));
		}
	}

	public static function reduceRight<A,B>(x:FingerTree<A>, z:B, f:A->B->B):B
	{
		function reduceDeep(pr, m, sf)
		{
			var r1 = Digits.reduceRight.bind(_,_,f);
			var r2 = FingerTrees.reduceRight.bind(_,_,Nodes.reduceRight.bind(_,_,f));

			return r1(pr, r2(m, r1(sf, z)));
		}

		return switch (x)
		{
			case Empty: 				   z;
			case Single(a): 			   f(a,z);
			case Deep(pr, Lazy(m), sf):    reduceDeep(pr, m(), sf);
			case Deep(pr, Regular(m), sf): reduceDeep(pr, m, sf);
		}
	}

	public static function concat<A>(f1:FingerTree<A>, f2:FingerTree<A>):FingerTree<A>
	{
		return app3(f1, ImLists.mkEmpty(), f2);
	}

	public static function app3<A>(f1:FingerTree<A>, l:ImList<A>, f2:FingerTree<A>):FingerTree<A>
	{

		function deepApp3(pr1, m1, sf1, ts, pr2, m2, sf2)
		{
			function middle () {
				var l1 = Digits.toImList(sf1);
				var l2 = Digits.toImList(pr2);
				var l = ImLists.concat(ImLists.concat(l1, ts), l2);
				return app3(m1, nodes(l), m2);
			}
			return Deep(pr1, Lazy(Tools.memo(middle)), sf2);
		}



		return switch [f1, l, f2] {
			case [Empty, ts, xs]: Tools.liftRight(ts, xs, ImListReduce.instance);
			case [xs, ts, Empty]: Tools.liftLeft(ts, xs, ImListReduce.instance);
			case [Single(x), ts, xs]: pushFront(Tools.liftRight(ts, xs,  ImListReduce.instance), x);
			case [xs, ts, Single(x)]: pushBack (Tools.liftLeft(ts, xs, ImListReduce.instance), x);
			case [Deep(pr1, Regular(m1), sf1), ts, Deep(pr2, Regular(m2), sf2)]: deepApp3(pr1, m1,   sf1, ts, pr2, m2,   sf2);
			case [Deep(pr1, Lazy(m1),    sf1), ts, Deep(pr2, Regular(m2), sf2)]: deepApp3(pr1, m1(), sf1, ts, pr2, m2,   sf2);
			case [Deep(pr1, Regular(m1), sf1), ts, Deep(pr2, Lazy(m2),    sf2)]: deepApp3(pr1, m1,   sf1, ts, pr2, m2(), sf2);
			case [Deep(pr1, Lazy(m1),    sf1), ts, Deep(pr2, Lazy(m2),    sf2)]: deepApp3(pr1, m1(), sf1, ts, pr2, m2(), sf2);
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

	public static function reduceLeft<A,B>(x:FingerTree<A>, z:B, f:B->A->B):B
	{
		function reduceDeep(pr, m, sf)
		{
			var r1 = Digits.reduceLeft.bind(_,_,f).flip();

			var r3 = Nodes.reduceLeft.bind(_,_,f).flip();
			var r2 = FingerTrees.reduceLeft.bind(_,_,r3).flip();


			return r1(r2(r1(z, pr),m),sf);
		}
		return switch (x)
		{
			case Empty:  				   z;
			case Single(a): 			   f(z,a);
			case Deep(pr, Lazy(m), sf):    reduceDeep(pr, m(), sf);
			case Deep(pr, Regular(m), sf): reduceDeep(pr, m, sf);

		}
	}

	public static function first <A>(x:FingerTree<A>):Option<A>
	{
		return switch (x) {
			case Empty:None;
			case Single(a)
			   | Deep(One(a) | Two(a,_) | Three(a,_,_) | Four(a,_,_,_),_,_):Some(a);
		}
	}

	public static function last <A>(x:FingerTree<A>):Option<A>
	{
		return switch (x)
		{
			case Empty:None;

			case Single(a)
			   | Deep(_,_, One(a) | Two(_,a) | Three(_,_,a) | Four(_,_,_,a)):Some(a);

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

			return Deep(sfMap, Regular(mMap), pfMap);
		}

		return switch (x)
		{
			case Empty:Empty;
			case Single(a): Single(f(a));
			case Deep(sf,Lazy(m),pf): deepMap(sf, m(), pf);
			case Deep(sf,Regular(m),pf): deepMap(sf, m, pf);

		}
	}

	public static function pushFront <A>(x:FingerTree<A>, a:A):FingerTree<A>
	{
		return switch (x)
		{
			case Empty: 					 		  Single(a);
			case Single(b): 				 		  Deep(One(a), Regular(Empty), One(b));
			case Deep(Four(b,c,d,e), Regular(m), sf): Deep(Two(a,b), pushFrontHelper2(m,c,d,e), sf);
			case Deep(Four(b,c,d,e), Lazy(m), sf): 	  pushFrontHelper1(a,b,c,d,e, m,sf);
			case Deep(One(b), m, sf): 		          Deep(Two(a,b), m, sf);
			case Deep(Two(b,c), m, sf):               Deep(Three(a,b,c), m, sf);
			case Deep(Three(b,c,d), m, sf):           Deep(Four(a,b,c,d), m, sf);
		}
	}












	static function pushFrontHelper2 <A>(m, c,d,e)
	{
		return Lazy(pushFront.bind(m, Node3(c,d,e)));
	}

	static function pushBackHelper1 <A>(pf:Digit<A>, m:Void->FingerTree<Node<A>>, b,c,d,e,z):FingerTree<A>
	{
		return Deep(pf, Lazy(Tools.memo(function () return pushBack(m(), Node3(b, c, d)))), Two(e,z));
	}

	static function pushBackHelper2 <A>(m,b,c,d)
	{
		return Lazy(pushBack.bind(m, Node3(b, c, d)));
	}

	// public static function pushBack <A>(x:FingerTree<A>, z:A):FingerTree<A>
	// {
	// 	return switch (x) {
	// 		case Empty: 					 			Single(z);
	// 		case Single(a): 				 			Deep(One(a), Regular(Empty), One(z));
	// 		case Deep(pf, Regular(m), Four(b,c,d,e)): 	Deep(pf, Lazy(pushBack.bind(m, Node3(b, c, d))), Two(e,z));
	// 		case Deep(pf, Lazy(m), Four(b,c,d,e)): 		Deep(pf, Lazy(Tools.memo(function () return pushBack(m(), Node3(b, c, d)))), Two(e,z));
	// 		case Deep(pf, m, One(b)): 		 			Deep(pf, m, Two(b,z));
	// 		case Deep(pf, m, Two(b,c)):      			Deep(pf, m, Three(b,c,z));
	// 		case Deep(pf, m, Three(b,c,d)):  			Deep(pf, m, Four(b,c,d,z));
	// 	}
	// }
	public static function pushBack <A>(x:FingerTree<A>, z:A):FingerTree<A>
	{
		return switch (x) {
			case Empty: 					 			Single(z);
			case Single(a): 				 			Deep(One(a), Regular(Empty), One(z));
			case Deep(pf, Regular(m), Four(b,c,d,e)): 	Deep(pf, pushBackHelper2(m,b,c,d), Two(e,z));
			case Deep(pf, Lazy(m), Four(b,c,d,e)): 		pushBackHelper1(pf, m, b,c,d,e,z);
			case Deep(pf, m, One(b)): 		 			Deep(pf, m, Two(b,z));
			case Deep(pf, m, Two(b,c)):      			Deep(pf, m, Three(b,c,z));
			case Deep(pf, m, Three(b,c,d)):  			Deep(pf, m, Four(b,c,d,z));
		}
	}


}

class LazyListReduce implements Reduce<LazyList<In>> {

	public function reduceRight<A,B>(x:LazyList<A>, b:B, f:A->B->B):B
	{
		return LazyLists.foldRight(x,b,f);
	}

	public function reduceLeft<A,B>(x:LazyList<A>, b:B, f:B->A->B):B
	{
		return LazyLists.foldLeft(x,b,f);
	}

	public function new () {}
	@:noUsing @:implicit public static var instance:Reduce<LazyList<In>> = new LazyListReduce();
}

class ImListReduce implements Reduce<ImList<In>> {

	public function reduceRight<A,B>(x:ImList<A>, b:B, f:A->B->B):B
	{
		return ImLists.foldRight(x,b,f);
	}

	public function reduceLeft<A,B>(x:ImList<A>, b:B, f:B->A->B):B
	{
		return ImLists.foldLeft(x,b,f);
	}

	public function new () {}
	@:noUsing @:implicit public static var instance:Reduce<ImList<In>> = new ImListReduce();
}

class ArrayReduce implements Reduce<Array<In>> {

	public function reduceRight<A,B>(x:Array<A>, b:B, f:A->B->B):B
	{
		return Arrays.foldRight(x,b,f);
	}

	public function reduceLeft<A,B>(x:Array<A>, b:B, f:B->A->B):B
	{
		return Arrays.foldLeft(x,b,f);
	}

	public function new () {}
	@:noUsing @:implicit public static var instance:Reduce<Array<In>> = new ArrayReduce();
}

class Tools {




	public static function memo <X>(x:Void->X):Void->X
	{
		var r:Null<X> = null;
		return function () {
			if (r == null) r = x();
			return r;
		}
	}

	public static function toList <F,A>(x:F<A>, reduce:Reduce<F>):LazyList<A>
	{
		return reduce.reduceRight(x,LazyLists.mkEmpty(),LazyLists.cons.flip());
	}


	public static function liftLeft <F,A>(x:F<A>, ft:FingerTree<A>, reduce:Reduce<F>):FingerTree<A>
	{
		return reduce.reduceLeft(x,ft,FingerTrees.pushBack);
	}

	public static function liftRight <F,A>(x:F<A>, ft:FingerTree<A>, reduce:Reduce<F>):FingerTree<A>
	{
		return reduce.reduceRight(x,ft,FingerTrees.pushFront.flip());

	}

	public static function toTree <F,A>(x:F<A>, fromLeft:Bool, reduce:Reduce<F>):FingerTree<A>
	{
		return
			if (fromLeft) liftRight(x, Empty, reduce) else
			liftRight(x, Empty, reduce);

	}
}

enum Tree<A> {
	Zero(a:A);
	Succ(x:Tree<Node<A>>);
}

enum Node<A> {
	Node2(a1:A, a2:A);
	Node3(a1:A, a2:A, a3:A);
}

enum FingerTree<A> {
	Empty;
	Single(a:A);
	Deep(l:Digit<A>, f:FingerTreeMiddle<A>, r:Digit<A>);
}

enum FingerTreeMiddle<A> {
	Regular(f:FingerTree<Node<A>>);
	Lazy(f:Void->FingerTree<Node<A>>);
}

enum Digit<A> {
	One(a:A);
	Two(a1:A, a2:A);
	Three(a1:A, a2:A, a3:A);
	Four(a1:A, a2:A, a3:A, a4:A);
}


enum View<A,S> {
	ViewNil;
	ViewCons(a:A, x:Void->S);

}

enum Bounce<A> {
	Done(result:A);
	Call(thunk : Void->Bounce<A>);
}

class Trampolines {
	public static function trampoline<A>(bounce:Bounce<A>):A
	{
		return switch (bounce)
		{
			case Done(x): x;
			case Call(thunk): trampoline(thunk());
		}
	}
}



class FingerTreeTest {

	static public function main()
	{

		var x = FingerTree.Empty;
		var time = haxe.Timer.stamp();
		for (i in 0...10000) {
			x = x.pushFront(i);
		}


		while (!x.isEmpty()) {
		 	x = x.tailLeft();
		}

		trace("runtime ftree front: " + (haxe.Timer.stamp()-time));


		var x = FingerTree.Empty;
		var time = haxe.Timer.stamp();
		for (i in 0...10000) {
			x = x.pushBack(i);
		}

		while (!x.isEmpty()) {
		  	x = x.tailRight();
		}

		trace("runtime ftree back: " + (haxe.Timer.stamp()-time));



		var x = ImLists.mkEmpty();
		var time = haxe.Timer.stamp();
		for (i in 0...1000000) {
			x = ImLists.cons(x,i);
		}

		while (!ImLists.isEmpty(x)) {
			x = ImLists.tail(x);
		}

		trace("runtime imList: " + (haxe.Timer.stamp()-time));

		var x = new haxe.ds.GenericStack<Int>();
		var time = haxe.Timer.stamp();
		for (i in 0...1000000) {
			x.add(i);
		}

		while (!x.isEmpty()) {
			x.pop();
		}

		trace("runtime stack: " + (haxe.Timer.stamp()-time));


		var x = LazyLists.mkEmpty();
		var time = haxe.Timer.stamp();
		for (i in 0...20000) {
			x = LazyLists.cons(x,i);
		}

		while (!LazyLists.isEmpty(x)) {
			x = LazyLists.tail(x);
		}

		trace("runtime: " + (haxe.Timer.stamp()-time));



		trace(Tools.toList._(LazyLists.fromArray([1,2,3])).show._());

		var x = FingerTree.Empty;


		trace(x.pushFront(1).pushBack(2).pushFront(3).pushBack(7).last());


		var z = x.pushFront(1).pushFront(2).pushFront(3).pushFront(4).pushFront(5).pushFront(6);

		trace(z.first());

		trace(z);

		trace(z.last());

		trace(z);

		trace(x.pushFront(1).pushBack(2).pushFront(3).pushBack(7).first());

		trace(Tools.toTree._([1,2,3,4,5,6,7,8,9,10,11,12], true).last());
		trace(Tools.toTree._([1,2,3,4,5,6,7,8,9,10,11,12], true).toImListFromLeft().show._());
		trace(Tools.toTree._([1,2,3,4,5,6,7,8,9,10,11,12], true).toImListFromRight().show._());


		var t = Tools.toTree._(LazyLists.fromArray([1,2,3,4,5,6]), true);

		var doubleT = t.concat(t);
		var doubleT2 = t.concat(t);



		trace(doubleT);

		trace(doubleT.toImListFromLeft().show._());
		trace(doubleT.map(function (x) return x + 10).toImListFromLeft().show._());


		trace(doubleT.toImListFromRight().show._());

		while (!doubleT.isEmpty()) {
			trace(doubleT.headRight());
			doubleT = doubleT.tailRight();
		}

		while (!doubleT2.isEmpty()) {
			trace(doubleT2.headLeft());
			doubleT2 = doubleT2.tailLeft();
		}

		trace(t);
		trace(t.toImListFromLeft().show._());
		trace(t.toImListFromRight().show._());
		trace(t.tailLeft());
		trace(t.tailRight());
		trace(t.headLeft());
		trace(t.headRight());




		// trace(Tools.toTree._(LazyLists.fromArray([1,2,3,4,5,6]), true).tailRight());


		// trace(Digits.reduceRight(Four(1,2,3,4),scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons.flip()));
		// trace(Digits.reduceLeft(Four(1,2,3,4),scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons));

		// trace(Nodes.reduceRight(Node3(1,2,3),scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons.flip()));
		// trace(Nodes.reduceLeft(Node3(1,2,3),scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons));


		// var l = scuts.ds.ImLists.fromArray([1,2,3,4]);

		// trace(scuts.ds.ImLists.foldLeft(l, scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons));
		// trace(scuts.ds.ImLists.foldRight(l, scuts.ds.ImLists.mkEmpty(), scuts.ds.ImLists.cons.flip()));
	}

}