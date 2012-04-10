package ;


using hots.macros.TcContext;

using scuts.core.extensions.ArrayExt;

import hots.classes.Monad;
import hots.classes.MonoidAbstract;
import hots.instances.ValidationMonadPlus;
import scuts.core.types.Validation;
import hots.classes.SemigroupAbstract;

import hots.instances.ArrayMonoid;
import hots.Of;

using scuts.core.extensions.ValidationExt;

using hots.extensions.MonadExt;

enum MultiError<T> {
  Simple(e:T);
  Multiple(a:Array<T>);
}

class MultiErrorSemigroup<X> extends SemigroupAbstract<MultiError<X>> {
  public function new () {}
  override public function append (e1:MultiError<X>, e2:MultiError<X>):MultiError<X> {
    return switch (e1) {
      case Multiple(a1): switch (e2) 
      {
        case Multiple(a2): Multiple(a1.concat(a2));
        case Simple(a2): Multiple(a1.append(a2));
      }
      case Simple(a1): switch (e2) 
      {
        case Multiple(a2): Multiple(a2.cons(a1));
        case Simple(a2): Multiple([a1,a2]);
      }
    }
  }
}


enum FormError {
  InvalidUserName(userName:String);
  InvalidEmail(email:String);
  InvalidAge(age:Int);
}

enum FormSuccess {
  FormSuccess;
}

class FormSuccessSemigroup extends SemigroupAbstract<FormSuccess> {
  public function new () {}
  override public function append (e1:FormSuccess, e2:FormSuccess):FormSuccess return e1
}
class FormSuccessMonoid extends MonoidAbstract<FormSuccess> {
  public function new () {}
  override public function zero ():FormSuccess return FormSuccess
}



class ValidationSample 
{

  public static function validUserName(name:String):Bool
  {
    return name == "admin";
  }
  
  public static function validEmail(email:String):Bool
  {
    return email.indexOf("@") > -1;
  }
  
  public static function validAge(age:Int):Bool
  {
    return age >= 18;
  }
  
  
  public static function main () 
  {
    var loginInfo = { name : "admin", email : "foo", age : 13 };
    
    // lifting into Validation<MultiError<FormError>>, Success>
    var success = FormSuccess.toSuccess();
    var fail = function (x) return Simple(x).toFail();
    
    var validEmail = function (p) return if (validEmail(p.email))   success else fail(InvalidEmail(p.email));
    var validAge   = function (p) return if (validAge(p.age))       success else fail(InvalidAge(p.age));
    var validName  = function (p) return if (validUserName(p.name)) success else fail(InvalidUserName(p.name));
    
    // we initialize with success
    var a: Validation<MultiError<FormError>, FormSuccess> = FormSuccess.toSuccess();
    
    // monad
    
    var m = ValidationMonadPlus.get(new MultiErrorSemigroup());
    
    m.runDo(
      
    
    //m.
    
    
    
  }
  
  
}
