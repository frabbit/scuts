
package scuts.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import scuts.core.Arrays;

using scuts.core.Options;


class Enums {

	private static function extractEnumType(name:String) {
		var enumType = {
			var intf = Context.getLocalClass().get().interfaces;

			function mapI (x:{ t : Ref<ClassType>, params:Array<Type>}) {
				return switch (x.params[0]) {
					case TEnum(e,p):
						var r = TEnum(e, e.get().params.map(function (x) return x.t));
						
						Some(r);
					case _ : None;
				}
			}

			Arrays.some(intf, function (i) return i.t.get().name == name).flatMap(mapI);
		}
		return enumType;
	}

	public static function createSetterAndGetters ():Array<haxe.macro.Field> 
	{
		var enumType = extractEnumType("AutoEnumFields");
		
		var fields = enumType.map(function (x) {

			return EnumsImpl.createSetterAndGetters(x).concat(Context.getBuildFields());

		}).getOrElse(Context.getBuildFields);

		return fields;
		
	}


	

}