
package scuts.ht.instances;


import scuts.core.Ordering;
import scuts.core.Tuples;
import scuts.ht.builder.ShowBuilder;
import scuts.ht.classes.Eq;
import scuts.ht.classes.EqAbstract;
import scuts.ht.classes.Monoid;
import scuts.ht.classes.Ord;
import scuts.ht.classes.OrdAbstract;
import scuts.ht.classes.Semigroup;
import scuts.ht.classes.Show;

private typedef SG<X> = Semigroup<X>;

class TupleInstances {

  @:implicit @:noUsing
  public static function monoidTup2<A,B>(semiA:Monoid<A>, semiB:Monoid<B>):Monoid<Tup2<A,B>> return new Tup2Monoid(semiA, semiB);

  @:implicit @:noUsing
  public static function semigroupTup2<A,B>(semiA:SG<A>, semiB:SG<B>):SG<Tup2<A,B>> return new Tup2Semigroup(semiA, semiB);


  @:implicit @:noUsing
  public static function showTup2<A,B>(showA:Show<A>, showB:Show<B>):Show<Tup2<A,B>> {
    return ShowBuilder.create(function (x:Tup2<A,B>) return "Tup2(" + showA.show(x._1) + "," + showB.show(x._2) + ")");
  }


}

class Tup2Eq<A,B,X:Eq<In>> extends EqAbstract<Tup2<A,B>>
{
  var eq1:X<A>;
  var eq2:X<B>;

  public function new (eq1:X<A>, eq2:X<B>)
  {
    this.eq1 = eq1;
    this.eq2 = eq2;
  }

  override public inline function eq  (a:Tup2<A,B>, b:Tup2<A,B>):Bool
  {
    return Tup2s.eq(a, b, eq1.eq, eq2.eq);
  }

}

class Tup2Ord<A,B> extends OrdAbstract<Tup2<A,B>>
{
  var ord1:Ord<A>;
  var ord2:Ord<B>;

  public function new (ord1:Ord<A>, ord2:Ord<B>, eq:Eq<Tup2<A,B>>)
  {
    super(eq);
    this.ord1 = ord1;
    this.ord2 = ord2;
  }

  override public inline function compare  (a:Tup2<A,B>, b:Tup2<A,B>):Ordering
  {
    return switch (ord1.compare(a._1, b._1) ) {
      case LT: LT;
      case EQ: ord2.compare(a._2, b._2);
      case GT : GT;
    }
  }

}


class Tup2Monoid<A,B> extends Tup2Semigroup<A,B> implements Monoid<Tup2<A,B>>
{
  private var m1:Monoid<A>;
  private var m2:Monoid<B>;

  public function new (m1:Monoid<A>, m2:Monoid<B>) {
    super(m1,m2);
    this.m1 = m1;
    this.m2 = m2;
  }

  public inline function zero ():Tup2<A,B>
  {
    return Tup2.create(m1.zero(), m2.zero());
  }
}


class Tup2Semigroup<A,B> implements Semigroup<Tup2<A,B>>
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;

  public function new (s1:Semigroup<A>, s2:Semigroup<B>)
  {
    this.s1 = s1;
    this.s2 = s2;
  }

  public inline function append (a:Tup2<A,B>, b:Tup2<A,B>):Tup2<A,B>
  {
    return Tup2.create(s1.append(a._1, b._1), s2.append(a._2, b._2));
  }

}



class Tup3Semigroup<A,B,C> implements Semigroup<Tup3<A,B,C>>
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  private var s3:Semigroup<C>;

  public function new (s1:Semigroup<A>, s2:Semigroup<B>, s3:Semigroup<C>)
  {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
  }

  public inline function append (a:Tup3<A,B,C>, b:Tup3<A,B,C>):Tup3<A,B,C>
  {
    return Tup3.create(s1.append(a._1, b._1), s2.append(a._2, b._2), s3.append(a._3, b._3));
  }

}




class Tup4Monoid<A,B,C,D> implements Semigroup<Tup4<A,B,C,D>>
{
  private var s1:Semigroup<A>;
  private var s2:Semigroup<B>;
  private var s3:Semigroup<C>;
  private var s4:Semigroup<D>;

  public function new (s1:Semigroup<A>, s2:Semigroup<B>, s3:Semigroup<C>, s4:Semigroup<D>)
  {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
    this.s4 = s4;
  }

  public inline function append (a:Tup4<A,B,C,D>, b:Tup4<A,B,C,D>):Tup4<A,B,C,D>
  {
    return Tup4.create(s1.append(a._1, b._1), s2.append(a._2, b._2), s3.append(a._3, b._3), s4.append(a._4, b._4));
  }
}

class Tup4Semigroup<A,B,C,D, X:Semigroup<In>> implements Semigroup<Tup4<A,B,C,D>>
{
  private var s1:X<A>;
  private var s2:X<B>;
  private var s3:X<C>;
  private var s4:X<D>;

  public function new (s1:X<A>, s2:X<B>, s3:X<C>, s4:X<D>)
  {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
    this.s4 = s4;

  }

  public inline function append (a:Tup4<A,B,C,D>, b:Tup4<A,B,C,D>):Tup4<A,B,C,D>
  {
    return Tup4.create(s1.append(a._1, b._1), s2.append(a._2, b._2), s3.append(a._3, b._3), s4.append(a._4, b._4));
  }
}


/*
class Tup2Zero<A,B> implements Zero<Tup2<A,B>>
{
  private var m1:Zero<A>;
  private var m2:Zero<B>;

  public function new (m1:Zero<A>, m2:Zero<B>) {
    this.m1 = m1;
    this.m2 = m2;
  }

  public inline function zero ():Tup2<A,B>
  {
    return Tup2.create(m1.zero(), m2.zero());
  }
}
*/
/*
class Tup3Zero<A,B,C> implements Zero<Tup3<A,B,C>>
{
  private var m1:Zero<A>;
  private var m2:Zero<B>;
  private var m3:Zero<C>;

  public function new (m1:Zero<A>, m2:Zero<B>, m3:Zero<C>)
  {
    this.m1 = m1;
    this.m2 = m2;
    this.m3 = m3;
  }

  public inline function zero ():Tup3<A,B,C>
  {
    return Tup3.create(m1.zero(), m2.zero(), m3.zero());
  }
}
*/

/*
class Tup4Zero<A,B,C,D> implements Zero<Tup4<A,B,C,D>>
{
  private var m1:Zero<A>;
  private var m2:Zero<B>;
  private var m3:Zero<C>;
  private var m4:Zero<D>;

  public function new (m1:Zero<A>, m2:Zero<B>, m3:Zero<C>, m4:Zero<D>)
  {
    this.m1 = m1;
    this.m2 = m2;
    this.m3 = m3;
    this.m4 = m4;
  }

  public inline function zero ():Tup4<A,B,C,D>
  {
    return Tup4.create(m1.zero(), m2.zero(), m3.zero(), m4.zero());
  }
}
*/