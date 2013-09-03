package zippers;

import scuts.core.Options;
import scuts.ds.ImLists;

interface Zipper<E,A> 
{
	public function get (a:E):A;
	
	public function put (a:E, x:A):E;
	public function forward (a:E):Option<E>;

	public function modify (a:E, f:A->A):E;
	public function findNext (x:E, f:A->Bool):Option<E>;	

	public function findPrevious (x:E, f:A->Bool):Option<E>;

	public function back (a:E):Option<E>;

	public function toImList (x:E):ImList<A>;

}

interface NTreeZipper<E,A> 
{
	public function get (a:E):A;
	
	public function put (a:E, x:A):E;
	

	public function modify (a:E, f:A->A):E;

	public function findChild (x:E, f:A->Bool):Option<E>;	

	public function findParent (x:E, f:A->Bool):Option<E>;

	//public function findNextSibling (x:E, f:A->Bool):Option<E>;
	//public function findPreviousSibling (x:E, f:A->Bool):Option<E>;

	public function previousChild (a:E):Option<E>;
	public function nextChild (a:E):Option<E>;
	public function child (a:E, i:Int):Option<E>;
	public function parent (a:E):Option<E>;


	public function toImList (x:E):ImList<A>;

}


