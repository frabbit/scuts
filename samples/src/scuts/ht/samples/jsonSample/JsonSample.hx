
package scuts.ht.samples.jsonSample;

using scuts.core.Options;


using scuts.ht.core.Ht;

using scuts.ht.samples.jsonSample.Definition;


using scuts.ht.samples.jsonSample.Data;



class JsonSample 
{
	public static function main () 
	{
		
		trace(JsonTools.read(' { "a" : 1, "b" : [1,2,3], "c" : null, "d" : "i am äa string", "f" : 2.1, "g" : true}').write());



		var arrayPerson = [[new Person(20, "frank", [new Person(1, "anna", [])])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]];

		var arrayPersonJson = arrayPerson.toJson._();

		trace(arrayPersonJson);

		var arrayPersonString = JsonTools.write(arrayPersonJson);

		trace(arrayPersonString);

		trace(JsonTools.read(arrayPersonString));

		trace(JsonConverterSyntax.fromJson._(JsonTools.read(arrayPersonString), Ht.implicitly("Array<Array<Person>>")));
		


		var optionAsJson = JsonConverterSyntax.toJsonString._(Some(Some(5)));
		trace(optionAsJson);

		var option = JsonConverterSyntax.fromJsonString._(optionAsJson, Ht.implicitly("Option<Option<Int>>"));

		
		

		
		

		
		

		



		

		


		
		

		



		
		var optionAsJson2 = JsonConverterSyntax.toJsonString._(Some(None));
		trace(optionAsJson2);

		var imp1 = Ht.implicitly("Option<Option<Int>>");

		var option2 = JsonConverterSyntax.fromJsonString._(optionAsJson2, imp1);

		



		trace("1".toJson._());
		trace(["1"].toJson._());
		trace([1,2,3].toJson._());
		trace([[1],[2],[3]].toJson._());
		trace([[1.1],[2.1],[3.6]].toJson._());


		trace([[new Person(20, "frank", [])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]].toJson._());


		// let's change the String To Json implementation
		Ht.implicit(new CustomStringJsonConverter());
		

		


		var x : Iterable<Int> = [1,2];

		trace(x.toJson._());

		trace([Some(5)].toJson._());


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



