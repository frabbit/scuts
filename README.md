scuts
=====

The library scuts (alpha state and changes are likely) is an attempt to integrate haskell/scalaz-like type classes and higher order types in Haxe. It consists of multiple modules:

* scuts.core : core types and functions for working with them
* scuts.ht : type classes, type class instances, higher order types and implicit resolution algorithms
* scuts.ds : a few functional data structures
* scuts.reactive : classes and functions for functional reactive programming
* scuts.mcore : helper functions for working with macros
* scuts.macros : useful macros (most of them not working at the moment :()

The most important modules are scuts.core and scuts.ht. The next sections give an overview of how scuts.ht works and how it can be used with haxe.

haxelib installation
====================

You can use the current state of this library with haxelib git, just run the following commands:

	haxelib git scuts-core https://github.com/frabbit/scuts.git master scutsCore
	haxelib git scuts-mcore https://github.com/frabbit/scuts.git master scutsMCore
	haxelib git scuts-ds https://github.com/frabbit/scuts.git master scutsDs
	haxelib git scuts-reactive https://github.com/frabbit/scuts.git master scutsReactive
	haxelib git scuts-macros https://github.com/frabbit/scuts.git master scutsMacros
	haxelib git scuts-ht https://github.com/frabbit/scuts.git master scutsHt


scuts.ht
========


Higher Order Types
------------------

Type constructor polymorphism is essential to implement type classes like Monads, Functors etc. Haxe at its core is missing this functionality. Because of this, scuts simulates this feature with 2 special types: [Of](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/core/Of.hx) and [In](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/core/In.hx). 

Some Examples how these types relate to a scala-like type constructor notation:

<table>
	<tr>
		<th>Required</th><th>Simulated</th>
	</tr>
	<tr>
		<td>M&lt;T&gt;</td><td>Of&lt;M, T&gt;</td>
	</tr>
	<tr>
		<td>Array&lt;T&gt;</td><td>Of&lt;Array&lt;In&gt;, T&gt;</td>
	</tr>
	<tr>
		<td>Option&lt;T&gt;</td><td>Of&lt;Option&lt;In&gt;, T&gt;</td>
	</tr>
	<tr>
		<td>Array&lt;Option&lt;T&gt;&gt;</td><td>Of&lt;Array&lt;In&gt;, Option&lt;T&gt;&gt;</td>
	</tr>
	<tr>
		<td>M&lt;Option&lt;T&gt;&gt;</td><td>Of&lt;Array&lt;In&gt;, Option&lt;T&gt;&gt;</td>
	</tr>
	<tr>
		<td>A -&gt; B</td><td>OfOf&lt;In-&gt;In, A, B&gt;</td>
	</tr>
</table>

Type classes
------------

Type classes are implemented as interfaces and type class inheritance through interface implementation. Default implementations are provided in the form of abstract base classes.

Some Examples:

* [Pure](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Pure.hx)
* [Apply](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Apply.hx)
* [Bind](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Bind.hx)
* [Monad](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Monad.hx)
* [Functor](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Functor.hx)
* [Eq](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Eq.hx)

Ord with default implementations

* [Ord](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/Ord.hx)
* [OrdAbstract](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/classes/OrdAbstract.hx)

Type class instances can be found in [scuts.ht.instances](https://github.com/frabbit/scuts/tree/master/scutsHt/src/scuts/ht/instances).

Syntax for using Type classes
-----------------------------

The package [scuts.ht.syntax](https://github.com/frabbit/scuts/tree/master/scutsHt/src/scuts/ht/syntax) contains classes for working with type classes (all of them are imported with "using scuts.ht.Context"). For every type class there's a syntax class and a macro based syntax class (M suffix).

The class [scuts.ht.syntax.Eqs](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/syntax/Eqs.hx) for example defines the static function eq to physically compare 2 values. It takes 3 parameters, two of them are values of the same arbitrary type and the last one is the required type class which contains the implemented Eq type class instance. This function can be called like this:

	Eqs.eq(1,1, EqInstances.intEq);
	Eqs.eq([1],[1], EqInstances.arrayEq(EqInstances.intEq));
	Eqs.eq([[1]],[[1]], EqInstances.arrayEq(EqInstances.arrayEq(EqInstances.intEq)));

or with using

	1.eq(1, EqInstances.intEq);
	[1].eq([1], EqInstances.arrayEq(EqInstances.intEq));
	[[1]].eq([[1]], EqInstances.arrayEq(EqInstances.arrayEq(EqInstances.intEq)));


As you see in the second and third example, type classes compose. But the more complex your type gets the more complex is the expression for the type class. To get rid of explicitly passing of type classes the macro based syntax classes can be used.

The correspondend macro syntax class EqsM contains the macro function eq_ (the leading underscore is by convention) which takes only 2 parameters and resolves the required type class based on the argument types with the help of macros. It can be used like this:

	EqsM.eq_(1,1)
	EqsM.eq_([1],[1])
	EqsM.eq_([[1]],[[1]])
	
or with using

	1.eq_(1)
	[1].eq_([1])
	[[1]].eq_([[1]]) // compiles as EqInstances.arrayEq(EqInstances.arrayEq(EqInstances.intEq)).eq([[1]], [[1]]);

It is important to understand that the functions found in all of these macro syntax classes are just sugar on top of the `resolve` function which is described in the next section.

Implicit resolution of type classes
-----------------------------------

Type classes are resolved with the help of a resolver macro (function `resolve` in [scuts.ht.core.Ht](https://github.com/frabbit/scuts/blob/master/scutsHt/src/scuts/ht/core/Ht.hx)). It resolves the required type classes based on the current context of the function/macro call. 

The expression `1.eq_(1)` from the following section is just syntactic sugar for `Ht.resolve(Eqs.eq, 1, 1)`. To have a short and nice way to call arbitrary functions with implicit resolution, there is also an alias for resolve named `_` (yes, just an underscore ;)) which can be used via using on every function. To make things clear, the following calls are equivalent: 

	1.eq_(1) // using of eq_
	1.eq._(1,1) // using of eq and _
	Eqs.eq._(1,1) 
	Ht._(Eqs.eq, 1, 1)
	Ht.resolve(Eqs.eq, 1, 1)


The context is divided in 4 scopes which are checked in the following order: local, member, static and using. Implicits of parent classes are not taken into account currently, but this is planned.

Please take a look at the [test cases](https://github.com/frabbit/scuts/blob/master/scutsHt/test/scuts/ht/ImplicitScopeTests.hx) to get the general idea of scopes.

Local type classes can be registered for implicit resolution with the help of `Ht.implicit`, these type classes are only available in the current and in nested local scopes.

	// create an Ord<Int> with reversed int comparision, OrdBuilder.createByIntCompare is a helper function which 
	// creates an Ord Instance based on the given comparison function.
	var myIntOrd = OrdBuilder.createByIntCompare(
		function (x:Int, y:Int) return if (x < y) 1 else if (x > y) -1 else 0
	);

	Ht.implicit(myIntOrd); // registers myIntOrd and returns an expression like `var __implicit1__ = myIntOrd;`

	1.min_(2); // // generates __implicit1__.min(1, 2);

To find type classes inside of the using context `resolve` looks in all classes that are imported with `using` for public static variables and functions with metadata `@:implicit`. These are collected and considered as possible candidates. The arguments of implicit functions are resolved recursively, this allows the resolution of type classes which are composed from different scopes.

	var myIntOrd = OrdBuilder.createByIntCompare(
		function (x:Int, y:Int) return if (x < y) 1 else if (x > y) -1 else 0
	);

	// myIntOrd is not yet registered
	[1].min_([2]); // generates OrdInstances.arrayOrd(OrdInstances.intOrd).min([1], [2]);

	Ht.implicit(myIntOrd); // register myIntOrd

	[1].min_([2]); // // generates OrdInstances.arrayOrd(__implicit1__).min([1], [2]);

Examples of scuts.ht
--------------------

You can find some usage Examples in the [samples folder](https://github.com/frabbit/scuts/tree/master/samples), the source code of all examples can be found in [scuts.ht.samples](https://github.com/frabbit/scuts/tree/master/samples/src/scuts/ht/samples).
