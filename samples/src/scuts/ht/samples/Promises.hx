package scuts.ht.samples;

#if js

import haxe.Http;
import haxe.crypto.Md5;


import scuts.core.Unit;
import scuts.core.Validations;


using scuts.ht.Context;


using scuts.core.Promises;


class Promises 
{

  public static function print (s:Dynamic) {
    
    new js.JQuery("body").append("<p>"+s+"</p>");
  }

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
    new js.JQuery(cast js.Browser.document).ready(run);
  }

  public static function run (_) {

    inline function load (url) return loadData(url);
    
    
    function getTwo () return Do.run(
      s <= load("a.txt"),
      p <= load("b.txt"),
      pure( { s : s, p : p } )
    );
    
    var p = Do.run(
      x <= load("c.txt"),
      y <= getTwo(),
      z <= load("d.txt"),
      pure( { x: x, y: y, z: z } )
    );
    
    

    p.onSuccess(function (x) print("success: " + Std.string(x)));
    p.onFailure(function (x) print("failure: " + Std.string(x)));
  }
  
}

#end