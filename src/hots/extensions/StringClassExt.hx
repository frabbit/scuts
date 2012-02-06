package hots.extensions;
import hots.instances.StringEq;
import hots.instances.StringMonoid;
import hots.instances.StringOrd;
import hots.instances.StringShow;

class StringClassExt 
{
  public static function Show(c:Class<String>) return StringShow.get()
  public static function Eq(c:Class<String>) return StringEq.get()
  public static function Ord(c:Class<String>) return StringOrd.get()
  public static function Monoid(c:Class<String>) return StringMonoid.get()
}