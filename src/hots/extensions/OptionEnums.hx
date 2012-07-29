package hots.extensions;
import hots.classes.Monoid;
import hots.instances.OptionMonoid;
import hots.instances.StringEq;
import hots.instances.StringMonoid;
import hots.instances.StringOrd;
import hots.instances.StringShow;
import scuts.core.types.Option;
private typedef EO = Enum<Option<Dynamic>>;
#if macro
import haxe.macro.Expr;

#end

class OptionEnums
{
  public static function Show(_:EO) return StringShow.get()
  public static function Eq(_:EO) return StringEq.get()
  public static function Ord(_:EO) return StringOrd.get()
  
  @:macro public static function Monoid<T>(_:ExprRequire<EO>, inner:ExprRequire<Monoid<T>>) return OptionMonoid.getM(inner)
}