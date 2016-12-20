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
            <div class="foo">
              <raw content={s}/>
              <button onclick={function () alert("clicked!")} style="color: red">click me!</button>
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