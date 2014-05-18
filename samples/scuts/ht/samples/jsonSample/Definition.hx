package scuts.ht.samples.jsonSample;

import haxe.ds.Option;
import scuts.ht.core.Ht;

using scuts.ht.core.Ht;
using scuts.ht.samples.jsonSample.Data;
using Definition.ImplicitInstances;


using scuts.core.Iterables;
using scuts.core.Arrays;



class ArrayJsonConverter<T> implements JsonConverter<Array<T>>
{

	var jsonConverterT:JsonConverter<T>;

	public function new (jsonConverterT:JsonConverter<T>)
	{
		this.jsonConverterT = jsonConverterT;
	}

	public function toJson (t:Array<T>):JsonValue
	{
		return JsonArray(t.map(jsonConverterT.toJson));
	}

	public function fromJson (t:JsonValue):Array<T>
	{
		return switch (t)
		{
			case JsonArray(a): a.map(jsonConverterT.fromJson);
			case _: throw "Cannot convert " + t + " to Array";
		}
	}
}

class IntJsonConverter implements JsonConverter<Int> {

	public function new () {}

	public function toJson (t:Int):JsonValue
	{
		return JsonInt(t);
	}
	public function fromJson (t:JsonValue):Int
	{
		return switch (t)
		{
			case JsonInt(x): x;
			case _ : throw "Cannot convert " + t + " to Int";
		}
	}
}


class FloatJsonConverter implements JsonConverter<Float> {

	public function new () {}

	public function toJson (t:Float):JsonValue
	{
		return JsonFloat(t);
	}

	public function fromJson (t:JsonValue):Float
	{
		return switch (t)
		{
			case JsonFloat(x): x;
			case _ : throw "Cannot convert " + t + " to Float";
		}
	}
}

class StringJsonConverter implements JsonConverter<String> {

	public function new () {}

	public function toJson (t:String):JsonValue
	{
		return JsonString(t);
	}

	public function fromJson (t:JsonValue):String
	{
		return switch (t)
		{
			case JsonString(x): x;
			case _ : throw "Cannot convert " + t + " to String";
		}
	}
}




class IterableJsonConverter<T> implements JsonConverter<Iterable<T>>
{

	@:implicit var jsonConverterT:JsonConverter<T>;

	public function new (jsonConverterT:JsonConverter<T>)
	{
		this.jsonConverterT = jsonConverterT;
	}

	public inline function toJson (t:Iterable<T>):JsonValue {
		return JsonObject([
			"type" => JsonString("iterable"),
			"data" => JsonArray(Lambda.map(t, jsonConverterT.toJson).toArray())
		]);
	}

	public inline function fromJson (t:JsonValue):Iterable<T> {
		return switch (t)
		{
			case JsonObject(x):
				x.get("data").fromJson._(Ht.implicitly("Array<T>"));
			case _ : throw "Cannot convert " + t + " to Iterable";
		}
	}
}

class OptionJsonConverter<T> implements JsonConverter<Option<T>>
{

	@:implicit var jsonConverterT:JsonConverter<T>;

	public function new (jsonConverterT:JsonConverter<T>) {
		this.jsonConverterT = jsonConverterT;
	}

	public inline function fromJson (t:JsonValue):Option<T>
	{
		return switch (t) {
			case JsonObject(m): switch (m.get("type")) {
				case JsonString("None"): None;
				case JsonString("Some"):
					var impT = Ht.implicitly("T");
					Some(m.get("value").fromJson._(impT));
				case _ :
					throw "Cannot convert " + t + " to Option";
			}
			case x:
				throw "Cannot convert " + t + " to Option";
		}
	}

	public inline function toJson (t:Option<T>):JsonValue
	{
		return switch(t) {
			case None: JsonObject([
				"type" => JsonString("None")
			]);
			case Some(v): JsonObject([
				"type" => JsonString("Some"),
				"value" => v.toJson._()
			]);
		}
	}


}


class Person
{
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


class PersonJsonConverter implements JsonConverter<Person>
{
	// it's not
	@:implicit var intJsonConverter:JsonConverter<Int>;
	@:implicit var stringJsonConverter:JsonConverter<String>;



	public function new (intJsonConverter:JsonConverter<Int>, stringJsonConverter:JsonConverter<String>)
	{
		this.intJsonConverter = intJsonConverter;
		this.stringJsonConverter = stringJsonConverter;

	}

	public function toJson (p:Person):JsonValue
	{


		return
			JsonValue.JsonObject([
				"age" => intJsonConverter.toJson(p.age),
				"name" => stringJsonConverter.toJson(p.name),
				"children" => p.children.toJson._()
			]);
	}

	public function fromJson (p:JsonValue):Person
	{
		return switch (p)
		{
			case JsonObject(m):
				new Person(
					intJsonConverter.fromJson(m.get("age")),
					stringJsonConverter.fromJson(m.get("name")),
					m.get("children").fromJson._(Ht.implicitly("Array<Person>"))
					);
			case x:
				Scuts.error("cannot convert " + p + " into Person");
		}
	}
}

// provide the instances
class ImplicitInstances
{
	@:implicit
	public static var intJsonConverter : JsonConverter<Int> = new IntJsonConverter();

	@:implicit
	public static var floatJsonConverter : JsonConverter<Float> = new FloatJsonConverter();

	@:implicit
	public static var stringJsonConverter : JsonConverter<String> = new StringJsonConverter();


	@:implicit public static inline function iterableJsonConverter<T>(x:JsonConverter<T>):JsonConverter<Iterable<T>> return new IterableJsonConverter(x);

	@:implicit @:noUsing
	public static function arrayJsonConverter <T>(x:JsonConverter<T>):JsonConverter<Array<T>> return new ArrayJsonConverter(x);

	@:implicit @:noUsing
	public static function optionJsonConverter <T>(x:JsonConverter<T>):JsonConverter<Option<T>> return new OptionJsonConverter(x);

	@:implicit @:noUsing
	public static function personJsonConverter <T>(x1:JsonConverter<Int>, x2:JsonConverter<String>):JsonConverter<Person> return new PersonJsonConverter(x1,x2);

}

