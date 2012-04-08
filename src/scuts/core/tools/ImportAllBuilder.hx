package scuts.core.tools;
import haxe.macro.Compiler;
import haxe.macro.Context;
import neko.FileSystem;
import neko.io.File;
using scuts.core.extensions.StringExt;

class ImportAllBuilder
{

  public static function build(packs:Array<String>, target:String) 
  {
    var classPaths = Context.getClassPath();
    function create1 (pack:String, buf:StringBuf) 
    {
      var parts = pack.split(".");
      var packPath = "/" + pack.split(".").join("/") + (pack.length > 0 ? "/" : "");
      var packBase = pack + (pack.length > 0 ? "." : "");
      
      for (cp in classPaths) 
      {
        var folder = cp + packPath;
        for (f in FileSystem.readDirectory(folder)) 
        {
          var fullPath = folder + "/" + f;
          if (FileSystem.isDirectory(fullPath)) 
          {
            create1(packBase + f, buf);
          } 
          else if (fullPath.endsWith(".hx")) 
          {
            var lastSlash = fullPath.lastIndexOf("/")+1;
            buf.add("import ");
            buf.add(packBase);
            buf.add(fullPath.substr(lastSlash, fullPath.length - 3 - lastSlash));
            buf.add(";\n");
          }
          
        }
      }
    }
    var buf = new StringBuf();
    for (p in packs)
      create1(p, buf);
    
    buf.add("class ");
    buf.add(target);
    buf.add(" { static function main () {} }");
    var output = File.write(target + ".hx", false);
    output.writeString(buf.toString());
  }
  
}