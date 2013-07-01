package scuts.ht.syntax;

class EnumerationBuilder {

	public static function createByFromAndTo(from, to) 
	{
		return new EnumerationByFromAndTo(from, to);
	}		
}

class EnumerationByFromAndTo<T> extends scuts.ht.classes.EnumerationAbstract<T>
{

	var _fromEnum : T->Int;
	var _toEnum : Int->T;

	public function new (from, to) 
	{
		this._fromEnum = from;
		this._toEnum = to;
	}
	
	override public function toEnum (i:Int):T 
	{
		return this._toEnum(i);
	}
  
  	override public function fromEnum (i:T):Int 
  	{
  		return this._fromEnum(i);
  	}
}