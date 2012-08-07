package ;


using hots.macros.Resolver;

using scuts.core.extensions.Arrays;

import hots.classes.Monad;
import hots.classes.MonoidAbstract;
import hots.classes.Semigroup;
import hots.instances.ValidationMonad;
import hots.instances.ValidationSemigroup;

//import hots.instances.ValidationMonadPlus;
import scuts.core.types.Validation;
import hots.classes.SemigroupAbstract;

import hots.instances.ArrayMonoid;
import hots.Of;

using scuts.core.extensions.Validations;

using hots.extensions.MonadExt;

using hots.box.ValidationBox;

enum MultiError<T> {
  Simple(e:T);
  Multiple(a:Array<T>);
}

class MultiErrorSemigroup<X> extends SemigroupAbstract<MultiError<X>> {
  public function new () { }
  
  override public function append (e1:MultiError<X>, e2:MultiError<X>):MultiError<X> {
    return switch (e1) {
      case Multiple(a1): switch (e2) 
      {
        case Multiple(a2): Multiple(a1.concat(a2));
        case Simple(a2): Multiple(a1.appendElem(a2));
      }
      case Simple(a1): switch (e2) 
      {
        case Multiple(a2): Multiple(a2.cons(a1));
        case Simple(a2): Multiple([a1,a2]);
      }
    }
  }
}

class FirstSemigroup<X> extends SemigroupAbstract<X> {
  public function new () { }
  
  override public function append (e1:X, e2:X):X {
    return e1;
  }
}


enum FormError {
  InvalidUserName(userName:String);
  InvalidEmail(email:String);
  InvalidAge(age:Int);
}

typedef Person = { name : String, email : String, age : Int };




class ValidationSample 
{

  public static function validUserName(name:String):Bool
  {
    return name == "admin";
  }
  
  public static function validEmail(email:String):Bool
  {
    return email.indexOf("@") != -1;
  }
  
  public static function validAge(age:Int):Bool
  {
    return age >= 18;
  }
  
  
  public static function main () 
  {
    var loginInfo = { name : "admin", email : "foo", age : 13 };
    
    // lifting into Validation<MultiError<FormError>>, Success>
    var success = function (x:Person) return x.toSuccess();
    var fail = function (x) return Simple(x).toFail();
    
    var validEmail = function (p:Person) return if (validEmail(p.email))   success(p) else fail(InvalidEmail(p.email));
    var validAge   = function (p:Person) return if (validAge(p.age))       success(p) else fail(InvalidAge(p.age));
    var validName  = function (p:Person) return if (validUserName(p.name)) success(p) else fail(InvalidUserName(p.name));
    
    // we initialize with success
    
    
    // monad
    var vv:Validation<MultiError<FormError>, Person> = null;
    type(vv);
    //var m = Tc.forType('ValidationSemigroup<MultiErrorSemigroup<FormError>, Person>');
    
    var s:Semigroup<Person> = FirstSemigroup.get();
    
    var mon1 = vv.tc(Semigroup, [s]);
    
    
    var mon = ValidationSemigroup.get(MultiErrorSemigroup.get(), FirstSemigroup.get());
    
    
    
    var e1 = validEmail(loginInfo);
    var e2 = validAge(loginInfo);
    var e3 = validName(loginInfo);
    
    trace(mon.append(mon.append(e1,e2), e3));
    
    
    var m = ValidationMonad.get(MultiErrorSemigroup.get());
    
    var res = m.runDo(
      x <= validEmail(loginInfo).box(),
      y <= validAge(x).box(),
      z <= validName(y).box(),
      return z
    );
    
      
    trace(res);
    
    //m.
    
    
    
  }
  
  
}
