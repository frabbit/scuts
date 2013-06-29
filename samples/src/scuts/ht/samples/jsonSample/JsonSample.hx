package scuts.ht.samples.jsonSample;


using scuts.ht.core.Ht;
using scuts.ht.samples.jsonSample.Definition;

class JsonSample 
{
	public static function main () 
	{

		trace("1".toJson._());
		trace(["1"].toJson._());
		trace([1,2,3].toJson._());
		trace([[1],[2],[3]].toJson._());
		trace([[1.1],[2.1],[3.6]].toJson._());
		trace([[new Person(20, "frank", [])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]].toJson._());


		// let's change the String To Json implementation
		Ht.implicit(new CustomStringToJson());

		trace([[new Person(20, "frank", [])],[new Person(20, "tim", [])],[new Person(20, "jim", [new Person(5, "anna", [])])]].toJson._());
	}
}


class CustomStringToJson implements ToJson<String> 
{
	public function new () {}

	public function toJson (s:String) {
		return "++++" + s + "++++";
	}

}