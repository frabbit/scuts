package scuts.ht.samples.jsonSample;

import scuts.ht.core.Ht;
using scuts.ht.core.Ht;
using Definition.ToJsonSyntax;
using Definition.ImplicitInstances;


typedef Json = String;

interface ToJson<T> {
	public function toJson (t:T):Json;
}

class ArrayToJson<T> implements ToJson<Array<T>> {

	var toJsonT:ToJson<T>;

	public function new (toJsonT:ToJson<T>) {
		this.toJsonT = toJsonT;
	}

	public function toJson (t:Array<T>):Json {
		return "[" + t.map(toJsonT.toJson).join(",") + "]";
	}	
}

class IntToJson implements ToJson<Int> {

	public function new () {}

	public function toJson (t:Int):Json {
		return Std.string(t);
	}
}


class Person {
	public var age(default, null) : Int;
	public var name(default, null) : String;
	// recursive Person
	public var children(default, null) : Array<Person>;

	public function new (age, name, children) {
		this.age = age;
		this.name = name;
		this.children = children;
	}
}


class PersonToJson implements ToJson<Person> 
{
	// it's not 
	var intToJson:ToJson<Int>;
	var stringToJson:ToJson<String>;



	public function new (intToJson:ToJson<Int>, stringToJson:ToJson<String>) 
	{
		this.intToJson = intToJson;
		this.stringToJson = stringToJson;

	}

	public function toJson (p:Person):Json 
	{

		Ht.implicit(intToJson, stringToJson);
		
		return '{' + 
			    '"age" : ' + intToJson.toJson(p.age) + "," +
			    '"name" : ' + stringToJson.toJson(p.name) + "," +
			    '"children" : ' + p.children.toJson._() + 
			  ' }';
	}
}

class FloatToJson implements ToJson<Float> {

	public function new () {}

	public function toJson (t:Float):Json {
		return Std.string(t);
	}
}


class StringToJson implements ToJson<String> {

	public function new () {}

	public function toJson (t:String):Json {
		return '"$t"';
	}
}

class ToJsonSyntax {
	public static function toJson <T>(x:T, toJson:ToJson<T>) {
		return toJson.toJson(x);
	}
}

// provide the instances
class ImplicitInstances {
	@:implicit 
	public static var intToJson : ToJson<Int> = new IntToJson();

	@:implicit 
	public static var floatToJson : ToJson<Float> = new FloatToJson();

	@:implicit 
	public static var stringToJson : ToJson<String> = new StringToJson();

	@:implicit @:noUsing 
	public static function arrayToJson <T>(x:ToJson<T>):ToJson<Array<T>> return new ArrayToJson(x);

	@:implicit @:noUsing 
	public static function personToJson <T>(x1:ToJson<Int>, x2:ToJson<String>):ToJson<Person> return new PersonToJson(x1,x2);
}