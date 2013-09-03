
package zippers;

import zippers.ListZipperTest;


enum NTree<A> {
	NTree(a:A, nodes:ImList<NTree>);
}


enum NTreeZipper {
	NTreeZipper(before:ImList<A>, after:ImList<A>, content:NTree<A>, parents:ImList<NTree<A>>)
}

// class NTreeZipper<A> implements zippers.NTreeZipper<NTreeZipper<A>, A>
// {
// 	public function new () {}

// 	public function get (a:ListZipper<A>):A {
// 		return ListZippers.get(a);
// 	}
// 	public function put (a:ListZipper<A>, x:A):ListZipper<A> {
// 		return ListZippers.put(a, x);
// 	}
// 	public function forward (a:ListZipper<A>):Option<ListZipper<A>> {
// 		return ListZippers.forward(a);
// 	}
// 	public function back (a:ListZipper<A>):Option<ListZipper<A>> {
// 		return ListZippers.back(a);
// 	}

// 	public function modify (a:ListZipper<A>, f:A->A):ListZipper<A> {
// 		return ListZippers.modify(a, f);
// 	}

// 	public function findNext (e:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
// 		return ListZippers.findNext(e, f);
// 	}

// 	public function findPrevious (e:ListZipper<A>, f:A->Bool):Option<ListZipper<A>> {
// 		return ListZippers.findPrevious(e, f);
// 	}

// 	public function toImList (x:ListZipper<A>):ImList<A> 
// 	{
// 		return ListZippers.toImList(x);
// 	}
// }


class NTrees {

	




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

class NTreeZipperTest {

	public static function main () {

	}
}