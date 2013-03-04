package scuts1.syntax;
import scuts1.classes.Category;
import scuts1.core.OfOf;

class Categorys
{
  public static function id <A, Cat>(a:A, cat:Category<Cat>):OfOf<Cat, A, A> return cat.id(a);
  
  public static function next <A,B,C, Cat>(f:OfOf<Cat, A, B>, g:OfOf<Cat, B, C>, cat:Category<Cat>):OfOf<Cat,A, C> return cat.next(f,g);
  
  public static function dot <A,B,C, Cat>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>, cat:Category<Cat>):OfOf<Cat, A, C> return cat.dot(g,f);
  
  public static function back <A,B,C, Cat>(g:OfOf<Cat, B, C>, f:OfOf<Cat, A, B>, cat:Category<Cat>):OfOf<Cat,A, C> return cat.back(g,f);
  
}