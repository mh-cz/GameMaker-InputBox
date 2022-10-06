global.IBDATA = { focused_ib: undefined, focus_reset: true, arrow_switch_t: -1 };

function inputbox(text = "", template_ib = undefined) constructor {
	
	// customization
	ib_next = undefined;
	ib_prev = undefined;
	highlight_color = c_aqua;
	highlight_alpha = 0.3;
	line_color = merge_color(c_dkgray, c_white, 0.15);
	line_alpha = 1;
	bkg_color = merge_color(c_dkgray, c_black, 0.5);
	bkg_alpha = 1;
	bkg_color_focused = merge_color(c_dkgray, c_black, 0.25);
	bkg_alpha_focused = 1;
	font = -1;
	width = 200;
	height = 20;
	lcase = false;
	ucase = false;
	char_limit = infinity;
	width_limit = true;
	
	// touch these and your pc explodes
	str = "";
	cstr = str;
	cursor_pos = 0;
	has_focus = false;
	spam_time = room_speed * 0.2;
	spam_t = spam_time;
	spam_speed = room_speed * 0.025;
	spam_s = spam_speed;
	cursor_time = room_speed * 0.5;
	cursor_t = cursor_time;
	cursor_vis = true;
	sel1 = cursor_pos;
	sel2 = cursor_pos;
	sel1x = 0;
	sel2x = 0;
	cursx = 0;
	double_click_speed = room_speed * 0.2;
	dc_t = double_click_speed;
	double_click_hold = false;
	
	if text != "" set_text(text);
	if !is_undefined(template_ib) copy_look(template_ib);
	
	static focus = function() {
		global.IBDATA.focused_ib = self;
	}
	
	static copy_look = function(from) {
		if !is_undefined(from) {
			highlight_color = from.highlight_color;
			highlight_alpha = from.highlight_alpha;
			line_color = from.line_color;
			line_alpha = from.line_alpha;
			bkg_color = from.bkg_color;
			bkg_alpha = from.bkg_alpha;
			bkg_color_focused = from.bkg_color_focused;
			bkg_alpha_focused = from.bkg_alpha_focused;
			font = from.font;
			width = from.width;
			height = from.height;
			lcase = from.lcase;
			ucase = from.ucase;
		}
	}
	
	static draw = function(x, y, gui = true) {
		
		var mx = gui ? device_mouse_x_to_gui(0) : device_mouse_x(0);
		var my = gui ? device_mouse_y_to_gui(0) : device_mouse_y(0);
		
		var prev_c = draw_get_color();
		var prev_a = draw_get_alpha();
		var prev_f = draw_get_font();
		
		var slen = string_length(str);
		draw_set_font(font);
		
		var mouse_in_rect = point_in_rectangle(mx, my, x-8, y, x+width+8, y+height);
		
		dc_t = max(--dc_t, -1);
		
		if device_mouse_check_button_released(0, mb_left) {
			global.IBDATA.focus_reset = true;
			global.IBDATA.arrow_switch_t = -1;
		}
		else if device_mouse_check_button_pressed(0, mb_left) {
			if global.IBDATA.focus_reset {
				global.IBDATA.focus_reset = false;
				global.IBDATA.focused_ib = undefined;
				global.IBDATA.arrow_switch_t = room_speed * 0.1;
			}
			if mouse_in_rect global.IBDATA.focused_ib = self;
		}
		
		has_focus = global.IBDATA.focused_ib == self;
		
		if !has_focus {
			if ucase cstr = string_upper(str);
			else if lcase cstr = string_lower(str);
			else cstr = str;
		}
		else {
			
			if keyboard_check_pressed(vk_anykey) 
			or keyboard_check_released(vk_anykey) {
				spam_t = spam_time;
				spam_s = spam_speed;
			}
		
			if keyboard_check_released(vk_backspace) keyboard_string = "";
		
			var can_spam = false;
			if keyboard_check(vk_anykey) {
				if --spam_t < 0 {
					spam_t = spam_s;
					can_spam = true;
				}
				cursor_t = cursor_time;
				cursor_vis = true;
			}
		
			if --cursor_t < 0 {
				cursor_t = cursor_time;
				cursor_vis = !cursor_vis;
			}
			
			global.IBDATA.arrow_switch_t = max(-1, global.IBDATA.arrow_switch_t-1);
		
			if keyboard_check_pressed(vk_anykey) or can_spam {
			
				switch(keyboard_key) {
					
					case vk_up:
						if global.IBDATA.arrow_switch_t < 0 and !is_undefined(ib_prev) {
							global.IBDATA.arrow_switch_t = room_speed * 0.1;
							global.IBDATA.focused_ib = ib_prev;
							ib_prev.cursor_pos = min(cursor_pos, ib_prev.slen);
							ib_prev.sel1 = 0;
							ib_prev.sel2 = 0;
						}
						break;
					
					case vk_down:
						if global.IBDATA.arrow_switch_t < 0 and !is_undefined(ib_next) {
							global.IBDATA.arrow_switch_t = room_speed * 0.1;
							global.IBDATA.focused_ib = ib_next;
							ib_next.cursor_pos = min(cursor_pos, ib_next.slen);
							ib_next.sel1 = 0;
							ib_next.sel2 = 0;
						}
						break;
				
					case vk_right:
						if keyboard_check(vk_control) {
							for(var i = cursor_pos+1; i < slen; i++) {
								var ch = string_char_at(str, i+1);
								if ch == " " or ch == "," or ch == "." break;
								cursor_pos = i+1;
							}
						}
						else cursor_pos++;
					
						if sel1 != sel2 {
							cursor_pos = sel2;
							sel1 = sel2;
						}
						break;
				
					case vk_left:
						if keyboard_check(vk_control) {
							for(var i = cursor_pos-1; i > -1; i--) {
								var ch = string_char_at(str, i);
								if ch == " " or ch == "," or ch == "." break;
								cursor_pos = i-1;
							}
						}
						else cursor_pos--;
					
						if sel1 != sel2 {
							cursor_pos = sel2;
							sel1 = sel2;
						}
						break;
				
					case vk_backspace:
							if sel1 != sel2 {
								var from = min(sel1, sel2);
								var to = max(sel1, sel2);
								str = string_delete(str, from+1, to-from);
								cursor_pos = from;
								sel1 = cursor_pos;
								sel2 = cursor_pos;
							}
							else str = string_delete(str, cursor_pos--, 1);
						
							if keyboard_check(vk_control) {
								for(var i = cursor_pos; i > -1; i--) {
									var ch = string_char_at(str, i);
									if ch == " " or ch == "," or ch == "." break;
									str = string_delete(str, cursor_pos--, 1);
								}
							}
						break;
				
					case vk_delete:
							if sel1 != sel2 {
								var from = min(sel1, sel2);
								var to = max(sel1, sel2);
								str = string_delete(str, from+1, to-from);
								cursor_pos = from;
								sel1 = cursor_pos;
								sel2 = cursor_pos;
							}
							else str = string_delete(str, cursor_pos+1, 1);
						break;
					
					default:
						if keyboard_string != "" {
							if sel1 != sel2 {
								var from = min(sel1, sel2);
								var to = max(sel1, sel2);
								str = string_delete(str, from+1, to-from);
								cursor_pos = from;
								sel1 = cursor_pos;
								sel2 = cursor_pos;
							}
							var sl = string_length(keyboard_string);
							for(var i = 0; i <= sl; i++) {
								var ch = string_char_at(keyboard_string, i+1);
								if ucase cstr = string_upper(str);
								else if lcase cstr = string_lower(str);
								else cstr = str;
								if width_limit and string_width(cstr+ch) > width break;
								if char_limit and string_length(cstr) >= char_limit break;	
								str = string_insert(ch, str, cursor_pos+1);
								if i < sl cursor_pos++;
							}
						}
						keyboard_string = "";
						break;
				}
			
				switch(keyboard_key) {

					case ord("C"):
						if keyboard_check(vk_control) and sel1 != sel2 {
							var from = min(sel1, sel2);
							var to = max(sel1, sel2);
							clipboard_set_text(string_copy(str, from+1, to-from));
						}
						break;
				
					case ord("V"):
						if keyboard_check(vk_control) and clipboard_has_text() {
							if sel1 != sel2 {
								var from = min(sel1, sel2);
								var to = max(sel1, sel2);
								str = string_delete(str, from+1, to-from);
								cursor_pos = from;
								sel1 = cursor_pos;
								sel2 = cursor_pos;
							}
							var ct = clipboard_get_text();
							var sl = string_length(ct);
							for(var i = 0; i <= sl; i++) {
								var ch = string_char_at(ct, i+1);
								if ucase cstr = string_upper(str);
								else if lcase cstr = string_lower(str);
								else cstr = str;
								if width_limit and string_width(cstr+ch) > width break;
								if char_limit and string_length(cstr) >= char_limit break;	
								str = string_insert(ch, str, cursor_pos+1);
								if i < sl cursor_pos++;
							}
						}
						break;
				
					case ord("A"):
						if keyboard_check(vk_control) and slen != 0 {	
							sel1 = 0;
							sel2 = slen;
							sel1x = string_width(string_copy(cstr, 1, sel1));
							sel2x = string_width(string_copy(cstr, 1, sel2));
						}
						break;
				
					case ord("X"):
						if keyboard_check(vk_control) and sel1 != sel2 {
							var from = min(sel1, sel2);
							var to = max(sel1, sel2);
							clipboard_set_text(string_copy(str, from+1, to-from));
							str = string_delete(str, from+1, to-from);
							cursor_pos = from;
							sel1 = cursor_pos;
							sel2 = cursor_pos;
						}
						break;
				}
			}
		
			slen = string_length(str);
			cursor_pos = clamp(cursor_pos, 0, slen);
			
			if ucase cstr = string_upper(str);
			else if lcase cstr = string_lower(str);
			else cstr = str;
			
			if device_mouse_check_button(0, mb_left) and !double_click_hold {
			
				cursor_t = cursor_time;
				cursor_vis = true;
			
				var press = device_mouse_check_button_pressed(0, mb_left);
				var closest = infinity;
				for(var i = 0; i <= slen; i++) {
					var sw = string_width(string_copy(cstr, 1, i));
					var dist = abs(x+sw-mx);
					if dist < closest {
						closest = dist;
						cursor_pos = i;
						if press {
							sel1 = i;
							sel2 = i;
						}
						else sel2 = i;
					}
					else break;
				}
			
				if sel1 != sel2 {
					sel1x = string_width(string_copy(cstr, 1, sel1));
					sel2x = string_width(string_copy(cstr, 1, sel2));
					cursx = sel2x;
				}
				else cursx = string_width(string_copy(cstr, 1, cursor_pos));
			}
		
			var double_clicked = false;
			if device_mouse_check_button_pressed(0, mb_left) {
				if dc_t < 0 {
					dc_t = double_click_speed;
					sel1x = cursor_pos;
					sel2x = cursor_pos;
				}
				else {
					double_clicked = true;
				}
			}
		
			if !device_mouse_check_button(0, mb_left) double_click_hold = false;
		
			if double_clicked {
				double_click_hold = true;
				sel1 = 0;
				sel2 = slen;
				for(var i = cursor_pos+1; i < slen; i++) {
					var ch = string_char_at(cstr, i);
					if ch == " " or ch == "," or ch == "." {
						sel2 = i-1;
						break;
					}
				}
				for(var i = cursor_pos+1; i > -1; i--) {
					var ch = string_char_at(cstr, i);
					if ch == " " or ch == "," or ch == "." {
						sel1 = i;
						break;
					}
				}
				if sel1 != sel2 {
					sel1x = string_width(string_copy(cstr, 1, sel1));
					sel2x = string_width(string_copy(cstr, 1, sel2));
					cursx = sel2x;
				}
			}
		}
		
		draw_set_color(has_focus ? bkg_color_focused : bkg_color);
		draw_set_alpha(has_focus ? bkg_alpha_focused : bkg_alpha);
		draw_rectangle(x, y, x+width, y+height, false);
		
		draw_set_color(line_color);
		draw_set_alpha(line_alpha);
		draw_line(x, y+height, x+width, y+height);
		draw_set_color(prev_c);
		draw_set_alpha(prev_a);
		
		if has_focus {
			if keyboard_check(vk_anykey) {
				cursx = string_width(string_copy(cstr, 1, cursor_pos));
			}
		
			if sel1 != sel2 {
				draw_set_color(highlight_color);
				draw_set_alpha(min(1, highlight_alpha + 0.3));
				draw_rectangle(x+min(sel1x, sel2x), y, x+max(sel1x, sel2x), y+height, true);
				draw_set_alpha(highlight_alpha);
				draw_rectangle(x+min(sel1x, sel2x), y, x+max(sel1x, sel2x), y+height, false);
				draw_set_color(prev_c);
				draw_set_alpha(prev_a);
			}
			else if cursor_vis {
				draw_line(x+cursx, y, x+cursx, y+height);
			}
		}
		
		draw_text(x, y, cstr);
		draw_set_font(prev_f);
	}
	
	static get_text = function(with_case = false) {
		return with_case ? cstr : str;
	}
	
	static set_text = function(text) {
		
		draw_set_font(font);
		
		text = string(text);
		str = "";
		var sl = string_length(text);
		for(var i = 0; i <= sl; i++) {
			var ch = string_char_at(text, i+1);
			if ucase cstr = string_upper(str);
			else if lcase cstr = string_lower(str);
			else cstr = str;
			if width_limit and string_width(cstr+ch) > width break;
			if char_limit and string_length(cstr) >= char_limit break;	
			str += ch;
			cursor_pos++;
		}
		
		slen = string_length(str);
		cursor_pos = max(slen, 0);
		cursx = string_width(string_copy(cstr, 1, cursor_pos));
	}
}
