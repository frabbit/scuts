
package scuts.ds;

import scuts.core.Options;
import scuts.ht.instances.Eqs;
import utest.Assert;

using scuts.core.Functions;
using scuts.ds.FingerTrees;
using scuts.ds.ImLists;

class FingerTreeTest {

	
	public function new () {}


	public function testPushFrontAndTailAndHeadRight () 
	{
		var x1 = FingerTrees.mkEmpty().pushFront(1).pushFront(2);

		Assert.isTrue( Options.eq(Some(1), x1.headRight(), 			  Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), x1.tailRight().headRight(), Eqs.intEq.eq));
	}

	public function testPushFrontAndTailAndHeadLeft () 
	{
		var x1 = FingerTrees.mkEmpty().pushFront(1).pushFront(2);

		Assert.isTrue( Options.eq(Some(2), x1.headLeft(), 			  Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(1), x1.tailLeft().headRight(), Eqs.intEq.eq));
	}

	public function testPushBackAndTailAndHeadRight () 
	{
		var x1 = FingerTrees.mkEmpty().pushBack(1).pushBack(2);

		Assert.isTrue( Options.eq(Some(2), x1.headRight(), 			  Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(1), x1.tailRight().headRight(), Eqs.intEq.eq));
	}

	public function testPushBackAndTailAndHeadLeft () 
	{
		var x1 = FingerTrees.mkEmpty().pushBack(1).pushBack(2);

		Assert.isTrue( Options.eq(Some(1), x1.headLeft(), 			  Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), x1.tailLeft().headLeft(),  Eqs.intEq.eq));
	}

	public function testPushBackAndFrontAndTailAndHeadLeft () 
	{
		var x1 = FingerTrees.mkEmpty().pushBack(1).pushFront(0);
		Assert.isTrue( Options.eq(Some(0), x1.headLeft(), 			  Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(1), x1.tailLeft().headLeft(),  Eqs.intEq.eq));
	}

	public function testFolds () 
	{
		var x1 = FingerTrees.mkEmpty().pushBack(1).pushBack(2).pushBack(3);
		var r = FingerTrees.foldLeft(x1, 0, scuts.core.Ints.plus);

		Assert.isTrue(r == 6);

		var r = FingerTrees.foldRight(x1, 0, scuts.core.Ints.plus);

		Assert.isTrue(r == 6);

		// reduce where associativity matters

		var concat = function (a:String, x:Int) return a + "" + x;

		var r = FingerTrees.foldLeft(x1, "", concat);


		
		Assert.isTrue(r == "123");		


		var r = FingerTrees.foldRight(x1, "", concat.flip());


		Assert.isTrue(r == "321");

	}

	public function testConcat () 
	{
		var x1 = FingerTrees.mkEmpty().pushFront(1).pushBack(2);
		var x2 = FingerTrees.mkEmpty().pushFront(3).pushBack(4);

		var x3 = x1.concat(x2);

		Assert.isTrue( Options.eq(Some(1), x3.headLeft(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), x3.tailLeft().headLeft(),                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(3), x3.tailLeft().tailLeft().headLeft(), 		   Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(4), x3.tailLeft().tailLeft().tailLeft().headLeft(), Eqs.intEq.eq));
		

	}

	public function testTake () 
	{
		var x1 = FingerTrees.mkEmpty().pushFront(5).pushFront(4).pushFront(3).pushFront(2).pushFront(1);
		

		var threeLeft = x1.takeLeft(3);

		trace(threeLeft);

		Assert.isTrue( Options.eq(Some(1), threeLeft.headLeft(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), threeLeft.tailLeft().headLeft(),                        Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(3), threeLeft.tailLeft().tailLeft().headLeft(), 		       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(None,    threeLeft.tailLeft().tailLeft().tailLeft().headLeft(),  Eqs.intEq.eq));

		var threeRight = x1.takeRight(3);

		Assert.isTrue( Options.eq(Some(5), threeRight.headRight(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(4), threeRight.tailRight().headRight(),                        Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(3), threeRight.tailRight().tailRight().headRight(), 		       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(None,    threeRight.tailRight().tailRight().tailRight().headRight(),  Eqs.intEq.eq));
		
		

	}

	public function testDrop () 
	{
		var x1 = FingerTrees.mkEmpty().pushFront(5).pushFront(4).pushFront(3).pushFront(2).pushFront(1);
		

		var threeLeft = x1.dropRight(2);

		trace(threeLeft);



		trace(threeLeft.toImListFromLeft().toString(Std.string));

		Assert.isTrue( Options.eq(Some(1), threeLeft.headLeft(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), threeLeft.tailLeft().headLeft(),                        Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(3), threeLeft.tailLeft().tailLeft().headLeft(), 		       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(None,    threeLeft.tailLeft().tailLeft().tailLeft().headLeft(),  Eqs.intEq.eq));

		var threeRight = x1.dropLeft(2);

		Assert.isTrue( Options.eq(Some(5), threeRight.headRight(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(4), threeRight.tailRight().headRight(),                        Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(3), threeRight.tailRight().tailRight().headRight(), 		       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(None,    threeRight.tailRight().tailRight().tailRight().headRight(),  Eqs.intEq.eq));
		
		

	}

	public function testFromArray () 
	{
		var x = FingerTrees.fromArray([1,2]);
		Assert.isTrue( Options.eq(Some(1), x.headLeft(), 			                       Eqs.intEq.eq));
		Assert.isTrue( Options.eq(Some(2), x.tailLeft().headLeft(),                        Eqs.intEq.eq));

	}

	public function testToArray () 
	{
		var x = FingerTrees.fromArray([1,2]);
		Assert.same( [1,2], x.toArrayFromLeft());
		Assert.same( [2,1], x.toArrayFromRight());

	}

	public function testPartitionBy () 
	{
		var x1 = FingerTrees.fromArray([1,2,3,1,4,5]);
		
		var r = x1.partitionBy(function (x) return x < 3);

		var left = r._1.toArrayFromLeft();
		var right = r._2.toArrayFromLeft();
		
		Assert.same( [1,2,1], left);
		Assert.same( [3,4,5], right);

	}
}