# GameMaker InputBox
A simple single-line box for string entries  
  
  
You should rather use https://github.com/mh-cz/gmtf  
it's a bit faster and has more stuff in it  
  
  
<p align="center" width="100%">
    <img width="33%" src="https://user-images.githubusercontent.com/68820052/192277586-c7ce2c5a-17bf-464f-a8e7-73ca5cd805cf.gif"> 
</p>

Fixed: keyboard_string not being cleared before focus

### Supported:
- mouse selection
- double click to select a whole word
- overwriting selected text
- `backspace/delete`
- `ctrl + a` to select everything
- `ctrl + c/x/v` copy, cut, paste
- `ctrl + backspace` to delete a whole word
- `ctrl + left/right arrows` to skip a whole word
- switching between connected boxes with up/down arrows
- character limit
- width limit


### Functions
- `focus()` - force focus
- `copy_look(from)` - steal the look of another inputbox
- `draw(x, y, gui=true)` - position x, position y, if `gui` is true GUI mouse position will be used
- `get_text(with_case=false)` - get the string inside. if with_case is true it will return text affected by lcase/ucase
- `set_text(text)` - overwrite the text inside

  
### Variables
- `ib_next` (inputbox id) - focus this one when pressed `down`
- `ib_prev` (inputbox id) - focus this one when pressed `up`
- `highlight_color` (color) - mouse selection color
- `highlight_alpha` (real) - mouse selection alpha
- `line_color` (color) - color of the line below the box
- `line_alpha` (real) - alpha of the line below the box
- `bkg_color` (color) - background color (unfocused)
- `bkg_alpha` (real) - background alpha (unfocused)
- `bkg_color_focused` (color) - background color (focused)
- `bkg_alpha_focused` (real) - background alpha (focused)
- `font` (font) - font
- `width` (real) - width of the input area
- `height` (real) - height of the input area
- `lcase` (bool) - force drawing in lowercase
- `ucase` (bool) - force drawing in uppercase (will overwrite lcase if both are true)
- `char_limit` (real) - limit the number of characters
- `width_limit` (bool) - do not allow the text to go over the right border

### Example
```
/// CREATE EVENT
ib1 = new inputbox("Hi there");
ib2 = new inputbox("Hi there two");
ib3 = new inputbox("Hi there three");

// set some fonts
ib2.font = Font1;
ib3.font = Font2;

// set some cosmetic variables
ib2.lcase = true;
ib3.ucase = true;

// set some connections to be able to switch between boxes using arrows
ib1.ib_prev = ib3;
ib1.ib_next = ib2;
ib2.ib_prev = ib1;
ib2.ib_next = ib3;
ib3.ib_prev = ib2;
ib3.ib_next = ib1;

// force focus the first one
ib1.focus();
```
```
/// DRAW GUI
ib1.draw(50, 50);
ib2.draw(50, 50+25);
ib3.draw(50, 50+50);
```
or
```
/// DRAW
ib1.draw(50, 50, false); // set variable "gui" to false to use regular mouse instead of gui mouse 
ib2.draw(50, 50+25, false);
ib3.draw(50, 50+50, false);
```
