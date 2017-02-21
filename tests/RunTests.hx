package ;

import Hxx4Dom.*;
import js.Browser.*;

class RunTests {

  static function main() {
    
    travix.Logger.exit(
      try {
        var s = 'hello, <strong>world</strong>!';
        document.body.appendChild(
          hxx('
            <div class="foo" name="fooName">
              <p><i>Test italic</i></p>
              <p><b>Test Bold</b></p>
              <label></label>
              <p><label><i>Test Label</i></label></p>
              <p><label htmlFor="testComp">Test Label with htmlFor attribute</label></p>
              {import "test"}
              {import "test.hxx"}
              {import "./tests/test"}
              {import "./tests/test.hxx"}
              <raw content={s}/>
              <div>
                <button onclick={function () alert("clicked!")} style="color: red">click me!</button>
              </div>
            </div>
          ')
        );
        0;
      }
      catch (e:Dynamic) {
        travix.Logger.println(Std.string(e));
        500;
      }
    );
  }
  
}