# GameMaker InputBox
A simple single-line box for string entries  
  
### Supported:
- mouse selection
- double click to select a whole word
- `backspace/delete`
- `ctrl + c/x/v`
- `ctrl + backspace` to delete a whole word
- `ctrl + left/right arrows` to skip a whole word
- switching between connected boxes with up/down arrows
- character limit
- width limit


### funcs
- `focus()` - force focus
- `copy_look(from)` - steal the look of another inputbox
- `draw(x, y, gui=true)` - position x, position y, specification in which draw event it's being drawn
- `get_text(with_case=false)` - get the string inside. if with_case is true it will return text affected by lcase/ucase
- `set_text(text)` - overwrite the text inside

  
### vars
- `ib_next` (inputbox id) - focus this one when pressed `down` [default: undefined]
- `ib_prev` (inputbox id) - focus this one when pressed `up` [default: undefined]
- `highlight_color` (color) - mouse selection color
- `highlight_alpha` (real) - mouse selection alpha
- `line_color` (color) - color of the line below the box
- `line_alpha` (real) - alpha of the line below the box
- `bkg_color` (color) - background color (unfocused)
- `bkg_alpha` (real) - background alpha (unfocused)
- `bkg_color_focused` (color) - background color (focused)
- `bkg_alpha_focused` (real) - background alpha (focused)
- `font` (font) - font
- `width` (real) - width of the input area [default: 200]
- `height` (real) - height of the input area [default: 20]
- `lcase` (bool) - force drawing in lowercase
- `ucase` (bool) - force drawing in uppercase (will overwrite lcase if both are true)
- `char_limit` (real) - limit the number of characters
- `width_limit` (bool) - do not allow the text to go over the right border

### Example
```
/// CREATE EVENT
// define ibs
ib1 = new inputbox("Hi there");
ib2 = new inputbox("Hi there two");
ib3 = new inputbox("Hi there three");

// set fonts
ib2.font = Font1;
ib3.font = Font2;

// set some cosmetic variables
ib2.lcase = true;
ib3.ucase = true;

// set connections
ib1.ib_prev = ib3;
ib1.ib_next = ib2;
ib2.ib_prev = ib1;
ib2.ib_next = ib3;
ib3.ib_prev = ib2;
ib3.ib_next = ib1;

// focus the first one
ib1.focus();


```
