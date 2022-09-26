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
  
### vars
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
- `ucase` (bool) - force drawing in uppercase
- `char_limit` (real) - limit the number of characters
- `width_limit` (bool) - do not allow the text to go over the right border
