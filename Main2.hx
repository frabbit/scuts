
package ;

import haxe.ds.Option;

import scuts.ht.classes.Monad;
import scuts.core.Eithers;

using scuts.core.Promises;
import scuts.core.Tuples.*;

// implicit instances
using scuts.ht.instances.ArrayInstances;
using scuts.ht.instances.BoolInstances;
using scuts.ht.instances.IntInstances;
using scuts.ht.instances.FloatInstances;
using scuts.ht.instances.DateInstances;
using scuts.ht.instances.ListInstances;
using scuts.ht.instances.OptionInstances;
using scuts.ht.instances.StringInstances;
using scuts.ht.instances.PromiseInstances;
using scuts.ht.instances.EitherInstances;
using scuts.ht.instances.ArrayTInstances;
using scuts.ht.instances.OptionTInstances;
using scuts.ht.instances.PromiseTInstances;
using scuts.ht.instances.Function0Instances;
using scuts.ht.instances.Function1Instances;
using scuts.ht.instances.TupleInstances;


// syntax
using scuts.ht.syntax.Functors;
using scuts.ht.syntax.Monads;
using scuts.ht.syntax.Eqs;
using scuts.ht.syntax.Shows;
using scuts.ht.syntax.Semigroups;


// implicit syntax build macro
import scuts.ht.classes.Show;
import scuts.ht.syntax.ExplicitSyntax;

import scuts.ht.syntax.Do;

using scuts.ht.core.Ht;



class Main2 implements ExplicitSyntax
{
	public static function main ()
	{

		var res = [1,2,3].map( function (x) return x + 1, $ );
		trace(res);

		var x = [1,2,3].flatMap( function (x) return [x+1], $);
		trace(x);

		var x = Ht.resolve([1,2,3].flatMap, function (y) return [y+1]);
		trace(x);

		trace([true,false].eq([true,false], $));

		trace([1,2].eq([1,2], $));

		trace([[[1,2]]].eq([[[1,2]]], $));

		trace([[1]].flatten($));

		trace(doIt([1,2], $)[0]);

		trace([[1]].flatten($).show($));

		trace(doIt(Some(1),$).show($));

		var e:Either<Int, Int> = Right(1);

		trace(doIt(e,$).show($));

		var l = new List();
		l.add(1);
		l.add(2);
		trace(l.map(function (y) return y + 1,$).show($));

		trace(l.flatMap(function (y) return { var l = new List(); l.add(y + 1); l;},$).show($));

		trace("hey".show($));

		// different scope
		{
			var customShow = scuts.ht.builder.ShowBuilder.create(function (x) return "myString:" + x);
			// register customShow
			Ht.implicit(customShow);
			trace("hey".show($));
		}

		trace("hey".show($));

		var x = Promises.pure(1).append(Promises.pure(2),$);

		x.onSuccess(function (x) {
			trace(x);
		});

		var x = Promises.pure([[1]]).append(Promises.pure([[2]]),$);

		x.onSuccess(function (x) {
			trace(x.show($));
		});


		trace((function () return 1).append(function () return 2,$)()); // 3

		var f1 = function (x:Int) return x+1;
		var f2 = function (x:Int) return x+2;

		trace(f1.append(f2,$)(1)); // 5

		trace((function (x:Int) return Some(x+1)).append(function (x:Int) return Some(x+2),$ )(1).show($)); // Some(5)


		var x = Promises.pure(Some([1])).append(Promises.pure(Some([2])),$);

		x.onSuccess(function (x) {
			trace(x.show($));
		});

		trace([[1]].arrayT()	 .flatMap(function (y) return [[y + 1]]    .arrayT(),$ ).runT().show($));
		trace([Some(1)].optionT().flatMap(function (y) return [Some(y + 1)].optionT(),$).runT().show($));
		trace([Promises.pure(1)].promiseT().flatMap(function (y) return [Promises.pure(y + 1)].promiseT(),$).runT().show($));

		// nested transformers

		function lift<X>(x:Array<Option<Promise<X>>>) return x.optionT().promiseT();
		function run <X>(x:PromiseT<OptionT<Array<In>,In>,X>) return x.runT().runT();

		var x = lift([Some(Promises.pure(1))]);

		var s = x.flatMap(function (x) return lift([Some(Promises.pure(x+2))]),$);


		trace(run(s).show($));

		var res = Do.run(
			x <= Promises.pure(1),
			y <= Promises.pure(2),
			@pure (x + y)
		);
		trace( res.show($));

		var res = Do.run(
			x <= Some(1),
			y <= Some(2),
			@pure (x + y)
		);
		trace( res.show($));

		var res = Do.run(
			x <= [1],
			y <= [2],
			@pure (x + y)
		);
		trace( res.show($));

		var res = Do.run(
			x <= [Some(1)].optionT(),
			y <= [Some(2)].optionT(),
			@pure (x + y)
		);
		trace( res.runT().show($));

		var res = Do.run(
			x <= Some(1),
			y <= Some(2),
			@if (x+y > 3),
			@pure (x + y)
		);

		trace( res.show($));

		trace(tup2(1,"hey").append(tup2(2, " jo"),$).show($));
	}

	public static function doIt <M>(x:M<Int>, m:Monad<M>)
	{
		Ht.implicit(m);
		return x.flatMap(function (x) return m.pure(x+2),$);
	}
}