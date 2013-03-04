package ;
import haxe.Http;
import haxe.Md5;
import scuts1.box.PromiseBox;
import scuts1.Identity;
import scuts.core.Unit;
import scuts.core.Promise;
import scuts.core.Validation;
import scuts1.Do;

using scuts1.Identity;
using scuts1.ImplicitInstances;
using scuts1.ImplicitCasts;


using scuts.core.Promises;
using scuts1.core.Hots;

class Promises 
{

  public static function loadData(url:String):Promise<Validation<String, String>> 
  {
    
    var p = new Promise();
    try {
      var http = new Http(url);
      http.onData = function (data) {
        p.complete(Success(data));
      }
      
      http.onError = function (error) {
        p.complete(Failure(error + " for url " + url));
      }
      http.request(true);
    } catch (e:Dynamic) {
      p.complete(Failure("LoadError"));
    }
    return p;
  }
  
  public static function main() 
  {
    function load (url) return loadData(url).intoT();
    
    function getTwo () return Do.run(
      s <= load("http://spiegeloffline.de/moin/"),
      p <= load("http://spiegeloffline.de/moin/"),
      pure( { s : Md5.encode(s), p:Md5.encode(p) } )
    );
    
    var p = Do.run(
      x <= load("http://spiegeloffline.de/moin/"),
      y <= getTwo(),
      z <= load("http://spiegeloffline.de/moin/"),
      pure( { x: Md5.encode(x), y:y, z:Md5.encode(z) } )
    ).runT();
    

    p.onComplete(function (x) trace(x));
    
  }
  
}