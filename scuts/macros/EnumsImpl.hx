
package scuts.macros;

import haxe.ds.Option;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.ExprDef.ESwitch;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType.FFun;
import haxe.macro.Expr.Function;
import haxe.macro.Type.EnumField;
import haxe.macro.Type.EnumType;
import haxe.macro.Type;
import haxe.macro.Type.Ref;
import haxe.macro.Type.TEnum;
import haxe.macro.TypeTools;
import scuts.core.Arrays;
import scuts.core.Strings;


class EnumsImpl 
{

	public static function createSetterAndGetters (type:Type):Array<Field>
	{
		return Arrays.foldLeft(createSetterAndGetterFields(type),[],function (acc, x) return acc.concat([x.getter, x.setter, x.lens]));
	}

	public static function createSetterAndGetterFields (type:Type):Array<{ getter:Field, setter:Field, lens:Field}>
	{

		return switch (type) 
		{
			case TEnum(t,p):

				var tget = t.get();
				var keys = t.get().constructs.keys();
				return if (keys.hasNext()) {
					var k = keys.next();
					if (keys.hasNext()) {
						[];
					} else {
						var enumField = tget.constructs.get(k);
						createSettersAndGettersForEnumField(enumField, tget, type,t.get().params);
					}
					
				} else {
					[];
				}
			case _ :  [];
		}

		
	}

	public static function createSettersAndGettersForEnumField(ef:EnumField, e:EnumType, type:Type, p:Array<{t:Type, name:String}>):Array<{ getter:Field, setter:Field, lens:Field}> 
	{

		return switch (ef.type) 
		{
			case haxe.macro.Type.TFun(args,ret):
				var names = args.map(function (a) return a.name);
				[for (a in args) createSetterAndGetterForParam(a.t, a.name, names, ef, e, type, p) ];
			case _:
				[];
		}

	}

	public static function createSetterAndGetterForParam(t:Type, n:String, allNames:Array<String>, ef:EnumField, e:EnumType, type:Type, p:Array<{t:Type, name:String}>):{ getter:Field, setter:Field, lens:Field} 
	{
		var allNamesAsExprs = [for (a in allNames) macro $i{a}];

		var case1 = {
			values:[macro $i{ef.name}($a{allNamesAsExprs}) ],
			expr : macro $i{n}
		} 

		var switchExpr = { expr : ESwitch(macro x, [case1], null), pos : Context.currentPos()};

		var fieldAsCamel = Strings.firstToUppercase(n);

		var f:Function = {
			args : [
				{
					name : "x",
					opt:false,
					type : TypeTools.toComplexType(type)
				}
			],
			ret : TypeTools.toComplexType(t),

			params : e.params.map(function (p):TypeParamDecl return { name : p.name }),
			expr : macro return $switchExpr
			

		}
		
		

		var getter:Field = {
			name : n,
			access : [APublic, AStatic, AInline],
			kind : FFun(f),
			pos:Context.currentPos()
		}

		

		var setValue = "new" + fieldAsCamel;

		var allNamesAsExprs = [for (a in allNames) macro $i{a}];

		var allNamesSetAsExprs = [for (a in allNames) if (a == n) macro $i{setValue} else macro $i{a}];

		var case1 = {
			values:[macro $i{ef.name}($a{allNamesAsExprs}) ],
			expr : macro $i{ef.name}($a{allNamesSetAsExprs})
		} 

		var switchExpr = { expr : ESwitch(macro x, [case1], null), pos : Context.currentPos()};

		

		var f:Function = {
			args : [
				{
					name : "x",
					opt:false,
					type : TypeTools.toComplexType(type)
				},
				{
					name : setValue,
					opt:false,
					type : TypeTools.toComplexType(t)
				}
			],
			ret : TypeTools.toComplexType(type),

			params : e.params.map(function (p):TypeParamDecl return { name : p.name }),
			expr : macro return $switchExpr
			

		}
		
		trace(haxe.macro.ExprTools.toString({ expr:EFunction(null,f), pos:Context.currentPos()}));

		

		var setter:Field = {
			name : "set" + fieldAsCamel,
			access : [APublic, AStatic, AInline],
			kind : FFun(f),
			pos:Context.currentPos(),
		}

		var fieldComplex = TypeTools.toComplexType(t);
		var enumComplex = TypeTools.toComplexType(type);
		var lensComplex = macro : lenses.Lens<$enumComplex, $fieldComplex>;
		trace(haxe.macro.ComplexTypeTools.toString(lensComplex));
		var f:Function = {
			args : [],
			ret : lensComplex,

			params : e.params.map(function (p):TypeParamDecl return { name : p.name }),
			expr : macro return lenses.Lens.Lens.Lens($i{n}, $i{"set" + fieldAsCamel})
			

		}

		trace(haxe.macro.ExprTools.toString(f.expr));
		// FProp( get : String, set : String, ?t : Null<ComplexType>, ?e : Null<Expr> );
		var lens:Field = {
			name : n + "Lens",
			access : [APublic, AStatic],
			kind : FFun(f),
			pos:Context.currentPos(),
		}
		trace(f);

		//public static var toyLens:Lens<ToyBox, StringMap<Toy>> = Lens(ToyBoxes.toys, ToyBoxes.setToys);

		return { getter: getter, setter : setter, lens: lens };

		

		
	}



}