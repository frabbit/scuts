package scuts.ht.samples;

#if !excludeHtSamples

import haxe.Http;
import haxe.crypto.Md5;


import scuts.core.Unit;
import scuts.core.Validations;


using scuts.ht.Context;


using scuts.core.Promises;


class Promises 
{

  public static function loadData(url:String):Promise<String, String> 
  {
    
    var p = new Promise();
    try {
      var http = new Http(url);
      http.onData = function (data) {
        p.success(data);
      }
      
      http.onError = function (error) {
        p.failure(error + " for url " + url);
      }
      http.request(true);
    } catch (e:Dynamic) {
      p.failure("LoadError");
    }
    return p;
  }
  
  public static function main() 
  {
    inline function load (url) return loadData(url);
    
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
    );
    

    p.onSuccess(function (x) trace(Std.string(x)));
    
  }
  
}

#end