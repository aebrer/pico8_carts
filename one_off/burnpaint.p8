pico-8 cartridge // http://www.pico-8.com
version 32
__lua__

camera(-64,-64)
_set_fps(60)
poke(0x5f2d, 1) --enable mouse
seed = rnd(-1)

-- functions

function rnd_pixel()
 local px_x = (
  flr(rnd(128))
 ) - 64
 local px_y = (
  flr(rnd(128))
 ) - 64
 local pixel = {
  x=px_x,
  y=px_y
 }
 return(pixel)
end

function dither(cx,cy,loops,pull)

 for i=loops,1,-1 do 

  local rect_width = 2

  local pxl = rnd_pixel()
  pxl.x += cx
  pxl.y += cy
  c=pget(pxl.x,pxl.y)
  x = pxl.x * pull
  y = pxl.y * pull
  ovalfill(x-rect_width,y-rect_width,x+rect_width,y+rect_width,burn(c))
 end
end

function burn(c)
 local new_c = max(abs(c-1),1)
 return new_c
end

function next_color(direc)
 col_i += direc
 if col_i > #all_colors then
  col_i = 1
 end
 if col_i < 1 then
  col_i = #all_colors
 end
end


all_colors = {
 {0,0,0,-15,1,-4,12,6,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,-9,10,9,-7,-2,8,-8},
 {0,0,0,-13,3,-5,-6,-9,7,6,12,-4,1,-15,0,0},
 {0,-9,10,9,-7,-2,8,-8,0,-8,8,-2,-7,9,10,-9},
 {0,0,0,-13,3,-5,-6,-9,7,-9,-6,-5,3,-13,0,0},
 {0,0,0,-15,1,-4,12,6,7,6,12,-4,1,-15,0,0},
 {0,0,0,-15,1,-4,12,6,7,14,13,-3,2,-11,-14,0},
 {0,0,0,-13,3,-5,-6,-9,7,14,13,-3,2,-11,-14,0},
 {0,-9,10,9,-7,-2,8,-8,0,-14,-11,2,-3,13,14,7},
 {0,5,6,7,7,6,5,0,0,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-8,-8,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-4,-4,5,6,7,7,6,5,0},
 {0,5,6,7,7,6,5,-13,-13,5,6,7,7,6,5,0}
}

col_i = flr(rnd(#all_colors)) + 1

brush_size = 3
brush_changed = false

pal(all_colors[col_i], 1)
cls()


::_:: 

-- cls()

if stat(34) == 1 then
 --z/🅾️ button
 mouse_button_pressed = true
else
 mouse_button_pressed = false
end

if btn(4) then
 z_btn = true
else
 z_btn = false
end

if btn(5) then
 x_btn = true
else
 x_btn = false
end

if z_btn and not brush_changed then
 brush_size -= 1
 brush_size = max(brush_size, 1)
 brush_changed = true
end

if x_btn and not brush_changed then
 brush_size += 1
 brush_size = max(brush_size, 1)
 brush_changed = true
end

if mouse_button_pressed and not color_changed then
 next_color(1)
 color_changed = true
end

-- reset buttons
if not mouse_button_pressed and color_changed then
 color_changed = false
end
if not (z_btn or x_btn) and brush_changed then
 brush_changed = false
end

dither(0,0,200,1.0)

local x = stat(32) - 64
local y = stat(33) - 64

circfill(x,y,brush_size,#all_colors[col_i]-1)

flip()
pal(all_colors[col_i], 1) 


goto _
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
