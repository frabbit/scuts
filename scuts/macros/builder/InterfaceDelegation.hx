
package scuts.macros.builder;

import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Type.ClassField;

using scuts.core.Arrays;

class InterfaceDelegation {

	macro public static function build ():Array<Field> {
		var cl = Context.getLocalClass();
		var fields = cl.get().fields.get();

		var buildFields = Context.getBuildFields();

		if (cl.get().meta.has(":forwardApplied")) return buildFields;

		var forwardFields = [for (f in fields) if (f.meta.has(":forward")) f];


		var decls = [for (f in forwardFields) createDecls(f, buildFields)];

		return buildFields.concat(decls.flatten());




	}

	public static function createDecls (f:ClassField, classFields:Array<Field>):Array<Field>
	{
		return [];
	}

}