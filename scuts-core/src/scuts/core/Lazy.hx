package scuts.core;


@:callable abstract Lazy<T>(Void->T) {

	public function new (x:Void->T) this = x;

	public function run ():Void->T return this;


}