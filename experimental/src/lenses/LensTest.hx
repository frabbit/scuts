package lenses;


using lenses.Lens;
using scuts.core.Maps;
using scuts.core.Arrays;



import haxe.ds.StringMap;
import scuts.macros.AutoEnumFields;
using scuts.core.Options;

using lenses.LensTest.ToyArrays;


enum ToyBox {
	ToyBox(toys:StringMap<Toy>);
}

enum ToyArray {
	ToyArray(toys:Array<Toy>);
}

enum ToyCondition {
	New;
	Used;
	Destroyed;
}

enum Toy {
	Toy(condition:ToyCondition, daysOld:Int);
}

enum Supi<X> {
	Supi(x:X):Supi<X>;
}



class ToyArrays implements AutoEnumFields<ToyArray>{

	public static function updateCondition(toyArray: ToyArray, index: Int, newCondition: ToyCondition): ToyArray 
	{
		var l = toyConditionLens(index);

		var r = l.set(toyArray, Some(newCondition));
		return r;
	}

	public static function toyLens (toyIndex:Int):Lens<ToyArray, Option<Toy>> 
	{
		var m = DefaultLenses.arrayLens(toyIndex);
		return toysLens().andThen(m);
	}

	public static function toyConditionLens(toyIndex:Int):Lens<ToyArray, Option<ToyCondition>> 
	{
		return toyLens(toyIndex).andThen(Toys.conditionLens().liftOption());
	}
}

class ToyBoxes implements AutoEnumFields<ToyBox>
{
	public static function updateCondition(toyBox: ToyBox, name: String, newCondition: ToyCondition): ToyBox {
		var l = toyConditionLens(name);

		var r = l.set(toyBox, Some(newCondition));
		return r;	
	}

	public static function toyLens (toyKey:String):Lens<ToyBox, Option<Toy>> 
	{
		var m = DefaultLenses.stringMapLens(toyKey);
		return toysLens().andThen(m);
	}

	public static function toyConditionLens(toyKey:String):Lens<ToyBox, Option<ToyCondition>> 
	{
		return toyLens(toyKey).andThen(Toys.conditionLens().liftOption());
	}
	
}
class Toys implements AutoEnumFields<Toy>
{
	
}


class DefaultLenses
{

	public static function arrayLens<B>(index:Int):Lens<Array<B>, Option<B>> 
	{
		function set (m:Array<B>,b:Option<B>) 
		{
			return b.map(Arrays.imSet.bind(m,index,_)).getOrElseConst(m);
		}
		return Lens(Arrays.elemAtOption.bind(_, index), set);
	}

	public static function stringMapLens<B>(key:String):Lens<StringMap<B>, Option<B>> 
	{
		function set (m:StringMap<B>,b:Option<B>) 
		{
			return b.map(StringMaps.imSet.bind(m,key,_)).getOrElseConst(m);
		}
		return Lens(StringMaps.getOption.bind(_, key), set);
	}

	public static function mapLens<A,B>(key:A, createEmptyMap:Void->Map<A,B>):Lens<Map<A,B>, Option<B>> 
	{
		function set (m:Map<A,B>,b:Option<B>) 
		{
			return b.map(Maps.imSet.bind(m,key,_,createEmptyMap)).getOrElseConst(m);
		}
		return Lens(Maps.getOption.bind(_, key), set);
	}

	

	


}



class LensTest {

	static public function main()
	{
		



		var box = ToyBox([ "teddy" => Toy(New, 0)]);
		var arr = ToyArray([ Toy(New, 0)]);



		var l = ToyBoxes.toyLens("teddy");

		

		trace(arr);
		trace(ToyArrays.updateCondition(arr, 0, Used));
		trace(arr);
		

		trace(l.set(box, Some(Toy(Used, 1))));

		// var condLens = ToyLenses.toyConditionLens;

		// trace(condLens.set(Toy(New, 0), Used));

		// var condOptLens = ToyLenses.toyConditionLens.liftOption();

		// trace(condOptLens.set(Some(Toy(New, 0)), Some(Used)));		

		// trace(box);
		trace(ToyBoxes.updateCondition(box, "teddy", Used));

		trace(ToyBoxes.updateCondition(box, "teddy", Used));
		
		var b2 = ToyBoxes.toyLens("myTeddy").set(box, Some(Toy(Used, 2)));

		trace(ToyBoxes.updateCondition(b2, "myTeddy", New));

		trace(ToyBoxes.toyConditionLens("myTeddy").mod(b2, Options.liftF1(function (v) {
			return switch (v) {
				case New:Destroyed;
				case Used:Destroyed;
				case _ : v;
			}
		})));

		//trace(box);

	}
}