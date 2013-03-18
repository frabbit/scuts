package ;

import haxe.Http;
import haxe.crypto.Md5;


import scuts.core.Unit;
import scuts.core.Validations;


using scuts.ht.Context;


using scuts.core.Promises;


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
    inline function load (url) return loadData(url).validationT();
    
    function getTwo () return Do.run(
      s <= load("testfile.txt"),
      p <= load("testfile.txt"),
      pure( { s : Md5.encode(s), p:Md5.encode(p) } )
    );
    
    var p = Do.run(
      x <= load("testfile.txt"),
      y <= getTwo(),
      z <= load("testfile.txt"),
      pure( { x: Md5.encode(x), y:y, z:Md5.encode(z) } )
    ).runT();
    

    p.onComplete(function (x) trace(Std.string(x)));
    
  }
  
}