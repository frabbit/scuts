package ;




// JS API
import haxe.Timer;
import js.JQuery;
import js.Lib;
import js.Browser;

import scuts.core.Unit;
import scuts.ht.instances.std.ValidationTOf;


// scuts.ht context
using scuts.ht.Context;

using scuts.core.Promises;
using scuts.core.Validations;

class Login 
{
  
  public static function login (userName:String, password:String):Promise<Validation<String, Bool>>
  {
    var p = new Promise();
    Timer.delay(function () {
      
      p.complete(Success(userName == "admin" && password == "pw"));
    }, 500);
    return p;
  }

  public static function showAdminPanel () 
  {
    var ap = new JQuery("#adminPanel");
    var p = new Promise();
    ap.show(500, p.complete.bind(Unit));
    return p;
  }

  public static function hideLoginBox () 
  {
    var p = new Promise();
    new JQuery("#loginBox").hide(500, p.complete.bind(Unit));
    return p;
  }

  public static function hideError () 
  {
    var p = new Promise();
    new JQuery("#loginError").hide(0, p.complete.bind(Unit));
    return p;
  }

  public static function showStatus (msg:String) 
  {
    var lbe = new JQuery("#loginError");
    lbe.html("status:" + msg);
    var p = new Promise();
    lbe.show(500, p.complete.bind(Unit));
    return p;
  }

  public static function showError (msg:String) 
  {
    var lbe = new JQuery("#loginError");
    lbe.html("error:" + msg);
    var p = new Promise();
    lbe.show(500, p.complete.bind(Unit));
    return p;
  }

  public static function loginClicked () 
  {
    var userName = new JQuery("#loginUserName").val();
    var pw = new JQuery("#loginPassword").val();
    

    var anim = Do.run(
      _ <= liftValidationT._(hideError()),
      _ <= liftValidationT._(showStatus("Validating login...")),
      success <= login(userName, pw).validationT(),
      liftValidationT._(hideError()),
      liftValidationT._(if (success) Do.run(
        hideLoginBox(),
        showAdminPanel(),
        pure(Unit)
      )
      else Do.run(
        showError("login failed"),
        pure(Unit)
      ))

    );
  }
  
  public static function liftValidationT <M,X,F>(x:Of<M,X>, m:Monad<M>):ValidationTOf<M, F, X> {
    return m.map(x, Success).validationT();
  }

  public static function main() 
  {
    
    var body = Browser.document.body;

    var loginButton = new JQuery("#loginButton");
    trace(loginButton);
    loginButton.click(function (_) {
      trace("click");
      loginClicked();
    });

    // Der Animationsvorgang
    

    // sobald die Animation vollständig durchgeführt wurde, wird "animation complete" ausgegeben.
    //anim.onComplete(function (_) trace("animation complete"));
    
    //anim.onCancelled(function () trace("animation cancelled"));
  }
}