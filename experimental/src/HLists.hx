
package ;

import haxe.ds.Option;

using HLists;




enum Unit { Unit; }


enum NEList<A> {
	NEList(a:A, tail:Option<NEList<A>>);
}

class NELists {
	public static function mkOne<A>(a:A):NEList<A>
	{
		return NEList(a, None);
	}

	public static function head<A>(l:NEList<A>):A
	{
		return switch (l) {
			case NEList(a,_):a;
		}	
	}

	public static function cons<A>(l:NEList<A>, val:A):NEList<A>
	{
		return switch (l) {
			case NEList(a,Some(t)): NEList(a, Some(cons(t, val)));
			case NEList(a, None): NEList(a, Some(mkOne(val))); 
		}
		
	}
}

enum HList<A,B> {
	HCons<X,C:HList<Dynamic, Dynamic>>(a:X, b:C):HList<X,C>;
	HNil:HList<Unit, Unit>;
}

class HLists 
{

	public static function mkLeaf<A>(a:A) return HCons(a,HNil);

	public static inline function head <A>(l:HList<A,HList<Dynamic, Dynamic>>):A
	{
		return switch (l) {
			case HCons(a,_):a;
		}
	}

	public static function tail <A,B,C,D>(l:HList<A,HList<B, HList<C,D>>>):HList<B,HList<C,D>>
	{
		return switch (l) {
			case HCons(_,t):t;
		}
	}

	static public function main()
	{

		// works as expected
		var x = HCons(1, HCons("hi", mkLeaf(1.1)));
		trace(x.tail().tail().head());
		

		// this compiles but it shouldn't because of the constraint for C
		HCons(1,2);

		NELists.mkOne(1);

		
		var x:X = null;
		trace(x.getSomething());
	}

}


class X {
	public inline function getSomething () {
		return this.getName()+1;
	}

	public inline function getName () {
		return "foo";
	}
	
}

