package scuts.tools;
import haxe.macro.Compiler;
import haxe.macro.Context;
import neko.FileSystem;
import neko.io.File;
using scuts.core.Strings;

class ImportAllBuilder
{

  public static function build(packs:Array<String>, target:String, folder:String) 
  {
    var classPaths = Context.getClassPath();
    
    function create1 (pack:String, buf:StringBuf) 
    {
      var parts = pack.split(".");
      var packPath = "/" + parts.join("/") + (pack.length > 0 ? "/" : "");
      var packBase = pack + (pack.length > 0 ? "." : "");
      
      for (cp in classPaths) 
      {
        var folder = cp + packPath;
        
        var sorted = FileSystem.readDirectory(folder);
        sorted.sort(function (a, b) {
          var isDirA = FileSystem.isDirectory(folder + "/" + a);
          var isDirB = FileSystem.isDirectory(folder + "/" + b);
          return if (!isDirA && isDirB) -1 else if (isDirA && !isDirB) 1 else 0;
        });
        
        for (f in sorted) 
        {
          var fullPath = folder + "/" + f;
          
          if (FileSystem.isDirectory(fullPath)) 
          {
            create1(packBase + f, buf);
          } 
          else if (fullPath.endsWith(".hx")) 
          {
            var lastSlash = fullPath.lastIndexOf("/") + 1;
            
            buf.add("import ");
            buf.add(packBase);
            buf.add(fullPath.substr(lastSlash, fullPath.length - 3 - lastSlash));
            buf.add(";\n");
          }
        }
      }
    }
    
    var buf = new StringBuf();
    
    for (p in packs) create1(p, buf);
    
    buf.add("class ");
    buf.add(target);
    buf.add(" { static function main () {} }");
    
    var f = folder == "" ? "" : folder + "/";
    
    var output = File.write(f +  target + ".hx", false);
    output.writeString(buf.toString());
  }
  
}