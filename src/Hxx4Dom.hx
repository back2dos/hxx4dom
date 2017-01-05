package;

#if !macro
import haxe.DynamicAccess;
import js.html.*;
import js.Browser.*;
import tink.core.Any;
import hxx4dom.Attr;

private typedef Children = Array<Hxx4Dom<Node>>;

abstract Hxx4Dom<T:Node>(T) from T to T { 
  
  @:from static function ofString(s:String):Hxx4Dom<Node>
    return document.createTextNode(s);
    
  @:noCompletion static public function flatten(children:Children):Node 
    return switch children {
      case []: document.createDocumentFragment();
      case [v]: v;
      case v: 
        var f = document.createDocumentFragment();
        for (c in v)
          f.appendChild(c);
        f;
    }
     

  static function tag(name:String, args:Dynamic, ?children:Children):Dynamic {
    var ret = document.createElement(name);
    
    for (f in Reflect.fields(args))
      switch [f, Reflect.field(args, f)] {
        case ['customAttributes', v]:
          
          for (f in Reflect.fields(v)) {
            switch '' + Reflect.field(v, f) {
              case 'false' | 'null' | 'undefined':
              case v: ret.setAttribute(f, v);
            }
          }
          
        case ['style', v]:
          ret.setAttribute(f, v);
        case [_, v]:
          Reflect.setField(ret, f, v);
      }
      
      
    if (children != null)
      for (c in children)
        ret.appendChild(c);
    return ret;
  }
    
  macro static public function hxx(e:haxe.macro.Expr):haxe.macro.Expr;
    
  static public function raw(attr:{ content: String } ):DocumentFragment {
    var ret = document.createDocumentFragment();
    var wrapper = document.createDivElement();
    
    wrapper.innerHTML = attr.content;
    
    for (i in 0...wrapper.childNodes.length)
      ret.appendChild(wrapper.firstChild);
      
    return ret;
  }
  static public inline function object(attr:{>Attr, type:String, data:String}, ?children:Children):ObjectElement return tag('object', attr, children);
  static public inline function param(attr:{>Attr, name:String, value:String}):ParamElement return tag('param', attr);
  
  static public inline function div(attr:Attr, ?children:Children):DivElement return tag('div', attr, children);
  static public inline function aside(attr:Attr, ?children:Children):Element return tag('aside', attr, children);
  static public inline function section(attr:Attr, ?children:Children):Element return tag('section', attr, children);
  
  static public inline function header(attr:Attr, ?children:Children):Element return tag('header', attr, children);
  static public inline function footer(attr:Attr, ?children:Children):Element return tag('footer', attr, children);
  static public inline function main(attr:Attr, ?children:Children):Element return tag('main', attr, children);
  
  static public inline function h1(attr:Attr, ?children:Children):HeadingElement return tag('h1', attr, children);
  static public inline function h2(attr:Attr, ?children:Children):HeadingElement return tag('h2', attr, children);
  static public inline function h3(attr:Attr, ?children:Children):HeadingElement return tag('h3', attr, children);
  static public inline function h4(attr:Attr, ?children:Children):HeadingElement return tag('h4', attr, children);
  static public inline function h5(attr:Attr, ?children:Children):HeadingElement return tag('h5', attr, children);
  
  static public inline function strong(attr:Attr, ?children:Children):Element return tag('strong', attr, children);
  static public inline function em(attr:Attr, ?children:Children):Element return tag('em', attr, children);
  static public inline function span(attr:Attr, ?children:Children):SpanElement return tag('span', attr, children);
  static public inline function a(attr:AnchorAttr, ?children:Children):AnchorElement return tag('a', attr, children);
  
  static public inline function p(attr:Attr, ?children:Children):ParagraphElement return tag('p', attr, children);
  static public inline function ul(attr:Attr, ?children:Children):UListElement return tag('ul', attr, children);
  static public inline function ol(attr:Attr, ?children:Children):OListElement return tag('ol', attr, children);
  static public inline function li(attr:Attr, ?children:Children):LIElement return tag('li', attr, children);
  static public inline function button(attr:{>Attr, @:optional var disabled(default, null):Bool; }, ?children:Children):ButtonElement return tag('button', attr, children);
  static public inline function textarea(attr:Attr, ?children:Children):TextAreaElement return tag('textarea', attr, children);
  
  static public inline function img(attr: ImgAttr ):ImageElement return tag('img', attr);
  static public inline function input(attr: InputAttr ):InputElement return tag('input', attr);  
}
#else
import haxe.macro.Expr;
import tink.hxx.*;

using haxe.macro.Context;
using haxe.macro.Tools;
using tink.CoreApi;

abstract Hxx4Dom({}) {
  static function nodify(children:Option<Expr>) {
    return children.map(function (e) return switch e {
      case macro $a{children}:
        return {
          pos: e.pos,
          expr: EArrayDecl(
            [for (c in children) switch c {
              case macro for ($head) $body: c;
              default: macro @:pos(c.pos) ($c : Hxx4Dom<js.html.Node>);
            }]
          )
        }
      case v: Context.fatalError('Cannot generate ${v.toString()}', v.pos);      
    });
  }
  static public function hxx(e:Expr) {    
    return Parser.parse(e, { child: macro : Hxx4Dom<js.html.Node> });
  }
}
#end