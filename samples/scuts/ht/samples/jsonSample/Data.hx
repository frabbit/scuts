
package scuts.ht.samples.jsonSample;

import haxe.ds.StringMap;
import haxe.Json;
import scuts.ht.builder.ShowBuilder;
import scuts.ht.classes.Show;
import scuts.ht.core.Ht;
import scuts.ht.core.Implicitly;
import scuts.ht.syntax.ImplicitSyntax;

using scuts.ht.syntax.Shows;

using scuts.ht.instances.StringInstances;
using scuts.ht.instances.BoolInstances;
using scuts.ht.instances.ArrayInstances;
using scuts.ht.instances.IntInstances;
using scuts.ht.instances.FloatInstances;

using scuts.core.Arrays;

enum JsonValue {
	JsonObject(m:Map<String, JsonValue>);
	JsonArray(a:Array<JsonValue>);
	JsonString(s:String);
	JsonFloat(n:Float);
	JsonInt(n:Int);
	JsonBool(b:Bool);
	JsonNull;
}



class JsonTools
{
	public static function write (v:JsonValue):String
	{
		return switch (v)
		{
			case JsonObject(m):
				var entries = [for (k in m.keys()) '"' + k + '"' + ":" + write(m.get(k))];

				"{" + entries.join(",") + "}";
			case JsonArray(a):
				"[" + a.map(write).join(",") + "]";
			case JsonFloat(n):
				Std.string(n);
			case JsonInt(n):
				Std.string(n);
			case JsonBool(b):
				Std.string(b);
			case JsonString(s):
				'"' + ~/([^\\]")/.map(s, function (e) return '\\"') + '"';
			case JsonNull:
				"null";
		}
	}

	public static function read (v:String):JsonValue
	{
		function convert (x:Dynamic):JsonValue {
			return switch (Type.typeof(x)) {
				case TFloat: JsonFloat(x);
				case TInt: JsonInt(x);
				case TClass(c) if (Type.getClassName(c) == "String"):
					JsonString(x);
				case TClass(c) if (Type.getClassName(c) == "Array"):
					JsonArray(Arrays.map(x, convert));
				case TObject:
					var fields = Reflect.fields(x);
					var map = [for (f in fields) f => convert(Reflect.field(x, f))];
					JsonObject(map);
				case TBool:
					JsonBool(x);
				case TNull:
					JsonNull;
				case other:
					throw "cannot parse json type is " + Std.string(other);
			}
		}
		var obj = Json.parse(v);
		return convert(obj);

	}
}



interface JsonConverter<T>
{
	public function toJson (x:T):JsonValue;
	public function fromJson (x:JsonValue):T;
}

class JsonConverterSyntax implements scuts.ht.syntax.ImplicitSyntax
{
	public static inline function toJsonString <T>(x:T, jsonConverter:JsonConverter<T>):String
	{
		return JsonTools.write(jsonConverter.toJson(x));
	}

	public static inline function toJson <T>(x:T, jsonConverter:JsonConverter<T>)
	{
		return jsonConverter.toJson(x);
	}

	public static function fromJson <T>(x:JsonValue, implicitT:Implicitly<T>, jsonConverter:JsonConverter<T>):T
	{
		return jsonConverter.fromJson(x);
	}

	public static function fromJsonString <T>(x:String, implicitT:Implicitly<T>, jsonConverter:JsonConverter<T>):T
	{
		return jsonConverter.fromJson(JsonTools.read(x));
	}

	@:implicit @:noUsing public static function show():Show<JsonValue> return ShowBuilder.create(function (j:JsonValue) {

		return switch (j) {
			case JsonObject(m):
				Ht.implicit(show());
				"Map(" + [for (k in m.keys()) k + ":" + (m.get(k):JsonValue).show()].join(",") + ")";
			case JsonArray(a):
				Ht.implicit(show());
				a.show();
			case JsonString(s): s.show();
			case JsonFloat(n): n.show();
			case JsonInt(n): n.show();
			case JsonBool(b): b.show();
			case JsonNull: "null";
		}
	});


}
