package scuts.ht.instances;

import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Show;

class BoolInstances {
  @:implicit public static var eq:Eq<Bool> = new BoolEq();
  @:implicit public static var ord:Ord<Bool> = new BoolOrd(eq);
  @:implicit public static var show:Show<Bool> = new BoolShow();
}

class BoolEq extends EqAbstract<Bool> {

  public function new () {}

  override public inline function eq (a:Bool, b:Bool):Bool return a == b;
}

class BoolOrd extends OrdAbstract<Bool>
{
  public function new (eq) super(eq);

  override public function less (a:Bool, b:Bool):Bool return !a && b;

  override public function min (a:Bool, b:Bool):Bool return !a ? a : b;

  override public function max (a:Bool, b:Bool):Bool return a ? a : b;
}

class BoolSemigroup implements Semigroup<Bool>
{
  public function new () {}

  public inline function append (a:Bool, b:Bool):Bool return a && b;
}

class BoolShow implements Show<Bool>
{
  public function new () {}

  public inline function show (v:Bool):String
  {
    return if (v) "true" else "false";
  }
}

class BoolMonoid extends BoolSemigroup {
	public inline function zero () return false;
}
