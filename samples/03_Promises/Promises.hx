package ;
import haxe.Http;
import haxe.Md5;
import hots.box.PromiseBox;
import hots.Identity;
import scuts.core.types.Unit;
import scuts.core.types.Promise;
import scuts.core.types.Validation;
import hots.Do;

using hots.Identity;
using hots.ImplicitInstances;
using hots.ImplicitCasts;


using scuts.core.extensions.Promises;
using hots.Hots;

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