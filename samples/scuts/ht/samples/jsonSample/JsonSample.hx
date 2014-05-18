
package scuts.ht.samples.jsonSample;

using scuts.core.Options;

using scuts.ht.syntax.Shows;

using scuts.ht.core.Ht;

using scuts.ht.samples.jsonSample.Definition;
using scuts.ht.instances.StringInstances;


using scuts.ht.samples.jsonSample.Data;



class JsonSample implements scuts.ht.syntax.ImplicitSyntax
{
	public static function main ()
	{

		trace(JsonTools.read(' { "a" : 1, "b" : [1,2,3], "c" : null, "d" : "i am a string", "f" : 2.1, "g" : true}').write());

		var arrayPerson = [[new Person(20, "frank", [new Person(1, "anna", [])])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]];

		var arrayPersonJson = arrayPerson.toJson();

		trace(arrayPersonJson.show());

		var arrayPersonString = JsonTools.write(arrayPersonJson);

		trace(arrayPersonString.show());

		trace(JsonTools.read(arrayPersonString).show());

		trace(JsonConverterSyntax.fromJson(JsonTools.read(arrayPersonString), Ht.implicitly("Array<Array<Person>>")));

		var optionAsJson = JsonConverterSyntax.toJsonString(Some(Some(5)));
		trace(optionAsJson);

		var option = JsonConverterSyntax.fromJsonString(optionAsJson, Ht.implicitly("Option<Option<Int>>"));


		var optionAsJson2 = JsonConverterSyntax.toJsonString(Some(None));
		trace(optionAsJson2);

		var imp1 = Ht.implicitly("Option<Option<Int>>");

		var option2 = JsonConverterSyntax.fromJsonString(optionAsJson2, imp1);





		trace("1".toJson());
		trace(["1"].toJson());
		trace([1,2,3].toJson().show());
		trace([[1],[2],[3]].toJson().show());
		trace([[1.1],[2.1],[3.6]].toJson().show());


		trace([[new Person(20, "frank", [])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]].toJson().show());


		// let's change the String To Json implementation
		Ht.implicit(new CustomStringJsonConverter());

		var x : Iterable<Int> = [1,2];

		trace(x.toJson().show());

		trace([Some(5)].toJson().show());

	}
}


class CustomStringJsonConverter extends StringJsonConverter
{
	public function new () {
		super();
	}

	override public function toJson (s:String) {
		return JsonString("++++" + s + "++++");
	}

	override public function fromJson (s:JsonValue):String {
		return throw "error";
		// return switch (s) {
		// 	case JsonString(s):

		// 		//var check:EReg = ~/^\+\+\+\+(.*)\+\+\+\+$/;


		// 	case _:
		// 		throw "cannot convert " + s + " to string";
		// }
	}
}



