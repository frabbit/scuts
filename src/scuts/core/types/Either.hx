package scuts.core.types;


enum Either < T1, T2> {
	Left(r:T1);
	Right(e:T2);
}
